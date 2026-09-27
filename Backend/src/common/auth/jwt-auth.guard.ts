import {
    CanActivate,
    ExecutionContext,
    Injectable,
    UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';
import type { AuthenticatedRequest } from './authenticated-request.interface';

@Injectable()
export class JwtAuthGuard implements CanActivate {
    constructor(
        private readonly jwtService: JwtService,
    ) { }

    async canActivate(
        context: ExecutionContext,
    ): Promise<boolean> {
        const request = context
            .switchToHttp()
            .getRequest<AuthenticatedRequest>();

        const token =
            this.extractTokenFromHeader(request);

        if (!token) {
            throw new UnauthorizedException(
                'Authentication token is required',
            );
        }

        try {
            const payload =
                await this.jwtService.verifyAsync<JwtPayload>(
                    token,
                );

            request.user = payload;

            return true;
        } catch {
            throw new UnauthorizedException(
                'Invalid or expired token',
            );
        }
    }

    private extractTokenFromHeader(
        request: AuthenticatedRequest,
    ): string | undefined {
        const authorization =
            request.headers.authorization;

        if (!authorization) {
            return undefined;
        }

        const [type, token] =
            authorization.split(' ');

        return type === 'Bearer'
            ? token
            : undefined;
    }
}