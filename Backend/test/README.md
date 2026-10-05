# Backend automated tests

## First suite: Auth + Users

Run:

```bash
npm install
npm run test:e2e:auth
```

The suite boots the real NestJS AppModule and exercises HTTP routing, ValidationPipe, AuthService, UsersService, bcrypt and JWT. PostgreSQL is replaced with an in-memory PrismaService test double so the suite cannot modify development data.

Covered scenarios:
- invalid registration payload -> 400
- successful app registration -> 201, password hidden
- duplicate email -> 409
- wrong password -> 401
- app login -> JWT
- authenticated GET /users/me -> 200
- missing JWT -> 401
- password change -> old password rejected, new password accepted

## Existing compile issue

A full `tsc --noEmit` currently stops at `migrations/app/20260920T2324_update_appointment_booking/migration.ts:179` because `#!` appears inside the TypeScript file. This predates the test suite and should be fixed separately.
