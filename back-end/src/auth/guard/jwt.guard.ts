import { ExecutionContext, Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';

@Injectable()
export class JwtGuard extends AuthGuard('jwt') {
  private readonly logger = new Logger(JwtGuard.name);

  constructor() {
    super();
  }

  handleRequest(err, user, info, context: ExecutionContext) {
    if (err || !user) {
      this.logger.warn("Jwt guard: Unauthorized access attempt.");
      throw err || new UnauthorizedException();
    }
  
    const request = context.switchToHttp().getRequest<Request>();
    request.user = user;
    return user;
  }
}
