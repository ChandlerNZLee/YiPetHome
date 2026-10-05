import {
    INestApplication,
    ValidationPipe,
} from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';

jest.mock('../src/prisma/prisma.service', () => ({
    PrismaService: class PrismaService { },
}));

const { PrismaService } = require('../src/prisma/prisma.service');

import { AuthController } from '../src/auth/auth.controller';
import { AuthService } from '../src/auth/auth.service';

import { UsersController } from '../src/users/users.controller';
import { UsersService } from '../src/users/users.service';

import { JwtAuthGuard } from '../src/common/auth/jwt-auth.guard';

type TestUser = {
    id: number;
    username: string;
    password: string;
    email: string;
    mobile: string;
    firstName: string;
    lastName: string;
    role: number;
    shopId: number | null;
    avatar: string | null;
    balance: number;
    resetToken?: string | null;
    resetExpires?: Date | null;
};

/**
 * In-memory replacement for PrismaService.
 *
 * This means:
 * - No real PostgreSQL connection
 * - No development database is modified
 * - AuthService and UsersService still run normally
 */
class InMemoryPrismaService {
    private users: TestUser[] = [];
    private nextId = 1;

    private matches(
        user: TestUser,
        condition: any,
    ): boolean {
        /**
         * Supports queries such as:
         *
         * user.email.ilike(email)
         */
        if (typeof condition === 'function') {
            const proxy: any = new Proxy(
                {},
                {
                    get: (_target, prop: string) => ({
                        ilike: (value: string) =>
                            String((user as any)[prop])
                                .toLowerCase() ===
                            value.toLowerCase(),
                    }),
                },
            );

            return Boolean(condition(proxy));
        }

        /**
         * Supports:
         *
         * where({ id: 1 })
         * where({ username: 'abc' })
         */
        return Object.entries(
            condition ?? {},
        ).every(
            ([key, value]) =>
                (user as any)[key] === value,
        );
    }

    private where = (condition: any) => ({
        first: async () =>
            this.users.find((user) =>
                this.matches(user, condition),
            ) ?? null,

        update: async (
            data: Partial<TestUser>,
        ) => {
            const user = this.users.find(
                (item) =>
                    this.matches(item, condition),
            );

            if (!user) {
                return null;
            }

            Object.assign(user, data);

            return {
                ...user,
            };
        },

        delete: async () => {
            const index =
                this.users.findIndex((user) =>
                    this.matches(user, condition),
                );

            if (index >= 0) {
                this.users.splice(index, 1);
            }
        },

        deleteAndCount: async () => {
            const before =
                this.users.length;

            this.users =
                this.users.filter(
                    (user) =>
                        !this.matches(
                            user,
                            condition,
                        ),
                );

            return (
                before -
                this.users.length
            );
        },
    });

    db = {
        orm: {
            public: {
                Users: {
                    where: this.where,

                    all: async () =>
                        this.users.map(
                            (user) => ({
                                ...user,
                            }),
                        ),

                    create: async (
                        data: Omit<TestUser, 'id'>,
                    ) => {
                        const user = {
                            id: this.nextId++,
                            ...data,
                        } as TestUser;

                        this.users.push(user);

                        return {
                            ...user,
                        };
                    },
                },
            },
        },
    };
}

describe(
    'Auth + Users API (e2e)',
    () => {
        let app: INestApplication | undefined;

        const newUser = {
            username: 'e2e_customer',
            password: 'Password123!',
            mobile: '0210000000',
            email: 'e2e@example.com',
            firstName: 'E2E',
            lastName: 'Customer',
        };

        beforeAll(async () => {
            /**
             * Test-only JWT secret.
             *
             * This does NOT need to match your
             * production JWT secret.
             */
            process.env.JWT_SECRET =
                'e2e-only-secret-do-not-use-in-production';

            const prisma =
                new InMemoryPrismaService();

            const moduleFixture:
                TestingModule =
                await Test.createTestingModule({
                    /**
                     * IMPORTANT:
                     *
                     * Do NOT import AppModule here.
                     *
                     * AppModule imports ScheduleModule,
                     * Stripe, AI, appointments, etc.
                     *
                     * None of those modules are needed
                     * for authentication tests.
                     */
                    imports: [
                        ConfigModule.forRoot({
                            isGlobal: true,
                        }),

                        JwtModule.register({
                            secret:
                                process.env.JWT_SECRET,

                            signOptions: {
                                expiresIn: '24h',
                            },
                        }),
                    ],

                    controllers: [
                        AuthController,
                        UsersController,
                    ],

                    providers: [
                        AuthService,
                        UsersService,
                        JwtAuthGuard,
                        {
                            provide: PrismaService,
                            useValue: prisma,
                        },
                    ],
                }).compile();

            app =
                moduleFixture.createNestApplication({
                    rawBody: true,
                });

            /**
             * Keep E2E validation behaviour
             * identical to main.ts.
             */
            app.useGlobalPipes(
                new ValidationPipe({
                    whitelist: true,
                    forbidNonWhitelisted: true,
                    transform: true,
                }),
            );

            await app.init();
        });

        afterAll(async () => {
            if (app) {
                await app.close();
            }
        });

        /**
         * ------------------------------------------------
         * TEST 1
         * DTO validation
         * ------------------------------------------------
         */
        it(
            'rejects an invalid registration payload',
            async () => {
                await request(
                    app.getHttpServer(),
                )
                    .post('/auth/app/register')
                    .send({
                        ...newUser,

                        email: 'not-an-email',

                        unexpectedField: true,
                    })
                    .expect(400);
            },
        );

        /**
         * ------------------------------------------------
         * TEST 2
         * Registration
         * ------------------------------------------------
         */
        it(
            'registers a customer and never returns the password',
            async () => {
                const response =
                    await request(
                        app.getHttpServer(),
                    )
                        .post(
                            '/auth/app/register',
                        )
                        .send(newUser)
                        .expect(201);

                expect(
                    response.body.success,
                ).toBe(true);

                expect(
                    response.body.user.email,
                ).toBe(newUser.email);

                expect(
                    response.body.user.role,
                ).toBe(2);

                /**
                 * Security check.
                 *
                 * Password hash must NEVER be
                 * returned to the client.
                 */
                expect(
                    response.body.user.password,
                ).toBeUndefined();
            },
        );

        /**
         * ------------------------------------------------
         * TEST 3
         * Duplicate registration
         * ------------------------------------------------
         */
        it(
            'rejects duplicate email registration',
            async () => {
                await request(
                    app.getHttpServer(),
                )
                    .post('/auth/app/register')
                    .send({
                        ...newUser,

                        username:
                            'another_username',
                    })
                    .expect(409);
            },
        );

        /**
         * ------------------------------------------------
         * TEST 4
         * Invalid password
         * ------------------------------------------------
         */
        it(
            'rejects login with a wrong password',
            async () => {
                await request(
                    app.getHttpServer(),
                )
                    .post('/auth/app/login')
                    .send({
                        email: newUser.email,
                        password:
                            'wrong-password',
                    })
                    .expect(401);
            },
        );

        /**
         * ------------------------------------------------
         * TEST 5
         * Login + JWT + protected API
         * ------------------------------------------------
         */
        it(
            'logs in, returns a JWT, and uses it to access GET /users/me',
            async () => {
                const login =
                    await request(
                        app.getHttpServer(),
                    )
                        .post(
                            '/auth/app/login',
                        )
                        .send({
                            email:
                                newUser.email,

                            password:
                                newUser.password,
                        })
                        .expect(201);

                expect(
                    login.body.accessToken,
                ).toEqual(
                    expect.any(String),
                );

                expect(
                    login.body.tokenType,
                ).toBe('Bearer');

                expect(
                    login.body.user.password,
                ).toBeUndefined();

                /**
                 * Use the real JWT returned
                 * from AuthService.
                 */
                const me =
                    await request(
                        app.getHttpServer(),
                    )
                        .get('/users/me')
                        .set(
                            'Authorization',
                            `Bearer ${login.body.accessToken}`,
                        )
                        .expect(200);

                expect(
                    me.body.email,
                ).toBe(newUser.email);

                expect(
                    me.body.username,
                ).toBe(
                    newUser.username,
                );

                expect(
                    me.body.password,
                ).toBeUndefined();
            },
        );

        /**
         * ------------------------------------------------
         * TEST 6
         * Protected API without JWT
         * ------------------------------------------------
         */
        it(
            'rejects GET /users/me without a JWT',
            async () => {
                await request(
                    app.getHttpServer(),
                )
                    .get('/users/me')
                    .expect(401);
            },
        );

        /**
         * ------------------------------------------------
         * TEST 7
         * Change password
         * ------------------------------------------------
         */
        it(
            'changes the password and accepts only the new password afterwards',
            async () => {
                /**
                 * First login using original
                 * password.
                 */
                const login =
                    await request(
                        app.getHttpServer(),
                    )
                        .post(
                            '/auth/app/login',
                        )
                        .send({
                            email:
                                newUser.email,

                            password:
                                newUser.password,
                        })
                        .expect(201);

                /**
                 * Change password using
                 * authenticated endpoint.
                 */
                await request(
                    app.getHttpServer(),
                )
                    .post(
                        '/auth/change-password',
                    )
                    .set(
                        'Authorization',
                        `Bearer ${login.body.accessToken}`,
                    )
                    .send({
                        currentPassword:
                            newUser.password,

                        newPassword:
                            'NewPassword456!',
                    })
                    .expect(201);

                /**
                 * Old password should
                 * stop working.
                 */
                await request(
                    app.getHttpServer(),
                )
                    .post(
                        '/auth/app/login',
                    )
                    .send({
                        email:
                            newUser.email,

                        password:
                            newUser.password,
                    })
                    .expect(401);

                /**
                 * New password should work.
                 */
                const newLogin =
                    await request(
                        app.getHttpServer(),
                    )
                        .post(
                            '/auth/app/login',
                        )
                        .send({
                            email:
                                newUser.email,

                            password:
                                'NewPassword456!',
                        })
                        .expect(201);

                expect(
                    newLogin.body.accessToken,
                ).toEqual(
                    expect.any(String),
                );
            },
        );
    },
);