import { Body, Controller, Post } from '@nestjs/common';

import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { ResetUserDto } from '../users/dto/reset-user.dto';
import { LoginWebDto } from './dto/login-web.dto';
import { LoginAppDto } from './dto/login-app.dto';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('/web/register')
    webRegister(
        @Body() createUserDto: CreateUserDto,
    ) {
        return this.authService.webRegister(createUserDto);
    }

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
        @Body() createUserDto: CreateUserDto,
    ) {
        return this.authService.appRegister(createUserDto);
    }

    @Post('/app/login')
    appLogin(@Body() loginAppDto: LoginAppDto) {
        return this.authService.appLogin(loginAppDto);
    }

    @Post('/app/reset')
    appReset(@Body('email') email: string) {
        return this.authService.appReset(email);
    }
}