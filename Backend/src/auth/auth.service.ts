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
import type { LoginWebDto } from './dto/login-web.dto';
import type { LoginAppDto } from './dto/login-app.dto';
import { RegisterAppDto } from './dto/register-app.dto';
import { ResetUserDto } from 'src/users/dto/reset-user.dto';
import { ChangePasswordDto } from './dto/change-password.dto';


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

  private sanitizeUser(user: any) {
    const safeUser = {
      ...user,
    };

    delete safeUser.password;
    delete safeUser.resetToken;
    delete safeUser.resetExpires;

    return safeUser;
  }

  async webLogin(loginWebDto: LoginWebDto) {
    const user = await this.usersService.findByUsername(
      loginWebDto.username,
    );

    if (!user) {
      throw new UnauthorizedException('Invalid username or password');
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
      role: user.role,
    };
    const accessToken = await this.jwtService.signAsync(payload);

    const safeUser = this.sanitizeUser(user);

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

  async appRegister(
    registerAppDto: RegisterAppDto,
  ) {
    const existingEmail =
      await this.prisma.db.orm.public.Users.where(
        (user) =>
          user.email.ilike(registerAppDto.email),
      ).first();

    if (existingEmail) {
      throw new ConflictException(
        'Email is already registered',
      );
    }

    const existingUsername =
      await this.prisma.db.orm.public.Users.where({
        username: registerAppDto.username,
      }).first();

    if (existingUsername) {
      throw new ConflictException(
        'Username is already registered',
      );
    }

    const hashedPassword = await bcrypt.hash(registerAppDto.password, 10);

    const user =
      await this.prisma.db.orm.public.Users.create({
        username: registerAppDto.username,
        password: hashedPassword,

        email: registerAppDto.email.toLowerCase(),
        mobile: registerAppDto.mobile,

        firstName: registerAppDto.firstName,
        lastName: registerAppDto.lastName,

        // App users
        role: 2,

        // New customers don't belong to a shop
        shopId: null,

        // New users have no avatar initially
        avatar: null,

        // Never accept initial balance from client
        balance: 0,
      });

    const { password, ...safeUser } = user;

    return {
      success: true,
      message: 'Registration successful',
      user: safeUser,
    };
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
      role: user.role,
    };
    const accessToken = await this.jwtService.signAsync(payload);

    const safeUser = this.sanitizeUser(user);

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
        success: true,
        message:
          'If the account exists, a reset email has been sent.',
      };
    }

    const token = randomBytes(32).toString('hex');
    const tokenHash = createHash('sha256')
      .update(token)
      .digest('hex');

    await this.prisma.db.orm.public.Users
      .where({
        id: user.id,
      })
      .update({
        resetToken: tokenHash,
        resetExpires: new Date(
          Date.now() + 30 * 60 * 1000,
        ),
      });

    try {
      const webUrl = process.env.WEB_URL;

      if (!webUrl) {
        throw new InternalServerErrorException(
          'WEB_URL is not configured',
        );
      }

      const resetPasswordUrl = `${webUrl}/reset-password?token=${encodeURIComponent(token)}`;

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

  async changePassword(
    userId: number,
    dto: ChangePasswordDto,
  ) {
    const user =
      await this.prisma.db.orm.public.Users
        .where({
          id: userId,
        })
        .first();

    if (!user) {
      throw new UnauthorizedException(
        'User not found',
      );
    }

    const passwordMatched =
      await bcrypt.compare(
        dto.currentPassword,
        user.password,
      );

    if (!passwordMatched) {
      throw new BadRequestException(
        'Current password is incorrect',
      );
    }

    const hashedPassword =
      await bcrypt.hash(
        dto.newPassword,
        10,
      );

    await this.prisma.db.orm.public.Users
      .where({
        id: userId,
      })
      .update({
        password: hashedPassword,
      });

    return {
      success: true,
      message:
        'Password changed successfully',
    };
  }
}