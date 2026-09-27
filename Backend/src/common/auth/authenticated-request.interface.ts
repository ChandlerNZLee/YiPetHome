import type { Request } from 'express';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

export interface AuthenticatedRequest extends Request {
    user: JwtPayload;
}