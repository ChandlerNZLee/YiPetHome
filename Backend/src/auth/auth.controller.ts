import { Body, Controller, Post, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { AuthService } from './auth.service';
import { ResetUserDto } from '../users/dto/reset-user.dto';
import { LoginWebDto } from './dto/login-web.dto';
import { LoginAppDto } from './dto/login-app.dto';
import { RegisterAppDto } from './dto/register-app.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('/web/login')
    webLogin(@Body() loginWebDto: LoginWebDto) {
        return this.authService.webLogin(loginWebDto);
    }

    @Post('/web/reset')
    webReset(@Body() resetUserDto: ResetUserDto) {
        return this.authService.webReset(resetUserDto);
    }

    @Post('/app/register')
    appRegister(
        @Body() RegisterAppDto: RegisterAppDto,
    ) {
        return this.authService.appRegister(RegisterAppDto);
    }

    @Post('/app/login')
    appLogin(@Body() loginAppDto: LoginAppDto) {
        return this.authService.appLogin(loginAppDto);
    }

    @Post('/app/reset')
    appReset(
        @Body()
        forgotPasswordDto: ForgotPasswordDto,
    ) {
        return this.authService.appReset(
            forgotPasswordDto.email,
        );
    }

    @Post('/change-password')
    @UseGuards(JwtAuthGuard)
    async changePassword(
        @Req() request: AuthenticatedRequest,
        @Body() dto: ChangePasswordDto,
    ) {
        return this.authService.changePassword(
            request.user.userId,
            dto,
        );
    }
}