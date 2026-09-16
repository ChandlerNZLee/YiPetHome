import { ConflictException, Injectable, UnauthorizedException, InternalServerErrorException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { randomBytes, createHash } from 'crypto';
import * as nodemailer from 'nodemailer';
import * as fs from 'fs';
import * as path from 'path';

import { PrismaService } from '../prisma/prisma.service';
import { UsersService } from '../users/users.service';

import type { JwtPayload } from './interfaces/jwt-payload.interface';
import { CreateUserDto } from '../users/dto/create-user.dto';
import type { LoginWebDto } from './dto/login-web.dto';
import type { LoginAppDto } from './dto/login-app.dto';
import { UpdateUserDto } from 'src/users/dto/update-user.dto';
import { ResetUserDto } from 'src/users/dto/reset-user.dto';


@Injectable()

export class AuthService {
  private readonly transporter: nodemailer.Transporter;

  constructor(
    private readonly prisma: PrismaService,
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {
    this.transporter = nodemailer.createTransport({
      host: process.env.MAIL_HOST,
      port: Number(process.env.MAIL_PORT) || 465,
      secure: process.env.MAIL_SECURE === 'true',
      auth: {
        user: process.env.MAIL_USER,
        pass: process.env.MAIL_PASSWORD,
      },
    });
  }

  async webRegister(createUserDto: CreateUserDto) {
    const existingUser = await this.prisma.db.orm.public.Users.where({ username: createUserDto.username }).first();

    if (existingUser) {
      throw new ConflictException('Username is already registered');
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    const user = await this.prisma.db.orm.public.Users.create({
      ...createUserDto,
      password: hashedPassword,
    });

    const { password, ...safeUser } = user;

    return safeUser;
  }

  async webLogin(loginWebDto: LoginWebDto) {
    const user = await this.usersService.findByUsername(
      loginWebDto.username,
    );

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const passwordMatched = await bcrypt.compare(
      loginWebDto.password,
      user.password,
    );

    if (!passwordMatched) {
      throw new UnauthorizedException('Invalid username or password');
    }

    const payload: JwtPayload = {
      userId: user.id,
      username: user.username,
    };
    const accessToken = await this.jwtService.signAsync(payload);

    const { password, ...safeUser } = user;

    return {
      accessToken,
      tokenType: 'Bearer',
      user: safeUser,
    };
  }

  async webReset(resetUserDto: ResetUserDto) {
    const tokenHash = createHash('sha256')
      .update(resetUserDto.token)
      .digest('hex');

    const user = await this.prisma.db.orm.public.Users.where({
      resetToken: tokenHash,
      resetExpires: {
        gt: new Date(),
      },
    }).first();

    if (!user) {
      throw new BadRequestException(
        'Reset password link is invalid or expired.',
      )
    }

    const hashedPassword = await bcrypt.hash(resetUserDto.password, 10);
    await this.prisma.db.orm.public.Users.where({ id: user.id }).update({
      password: hashedPassword,
      resetToken: null,
      resetExpires: null,
    });

    return {
      message: 'Password reset successfully.',
    };
  }

  async appRegister(createUserDto: CreateUserDto) {
    const existingUser = await this.prisma.db.orm.public.Users.where({ email: createUserDto.email }).first();

    if (existingUser) {
      throw new ConflictException('Email is already registered');
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    const user = await this.prisma.db.orm.public.Users.create({
      ...createUserDto,
      password: hashedPassword,
    });

    const { password, ...safeUser } = user;

    return safeUser;
  }

  async appLogin(loginAppDto: LoginAppDto) {
    const user = await this.usersService.findByEmail(
      loginAppDto.email,
    );

    if (!user || user.role != 2) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const passwordMatched = await bcrypt.compare(
      loginAppDto.password,
      user.password,
    );

    if (!passwordMatched) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const payload: JwtPayload = {
      userId: user.id,
      username: user.email,
    };
    const accessToken = await this.jwtService.signAsync(payload);

    const { password, ...safeUser } = user;

    return {
      accessToken,
      tokenType: 'Bearer',
      user: safeUser,
    };
  }

  async appReset(email: string) {
    const user = await this.usersService.findByEmail(
      email
    );

    if (!user) {
      return {
        success: false,
        message:
          'If the account exists, a reset email has been sent.',
      };
    }

    const token = randomBytes(32).toString('hex');
    const tokenHash = createHash('sha256')
      .update(token)
      .digest('hex');

    const updateUserDto: UpdateUserDto = {
      reset_token: tokenHash,
      reset_expires: new Date(
        Date.now() + 30 * 60 * 1000,
      )
    };
    await this.usersService.update(user.id, updateUserDto);

    try {
      const resetPasswordUrl =
        `http://localhost:5173/reset-password?token=${encodeURIComponent(token)}`;

      const templatePath = path.join(
        process.cwd(),
        'src',
        'auth',
        'templates',
        'reset-password.html'
      );
      let html = fs.readFileSync(templatePath, 'utf8');
      html = html.replace('{{RESET_PASSWORD_URL}}', resetPasswordUrl);

      const info = await this.transporter.sendMail({
        to: user.email,
        subject: 'Reset Your YiPet Password',
        html,
      });

      return {
        success: true,
        messageId: info.messageId,
        message:
          'If the account exists, a reset email has been sent.',
      };
    } catch (error) {
      console.error('Send mail failed:', error);

      throw new InternalServerErrorException('Failed to send email');
    }
  }
}