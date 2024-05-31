import { CanActivate, ExecutionContext, Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '@prisma/client';

@Injectable()
export class RolesGuard implements CanActivate {
  private readonly logger = new Logger(RolesGuard.name);

  constructor(private reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const roles = this.reflector.get<Role[]>('roles', context.getHandler());
    if (!roles) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      this.logger.error('No user found in request');
      throw new ForbiddenException('No user found in request');
    }

    const hasRole = roles.includes(user.role);
    if (!hasRole) {
      this.logger.warn(`Access denied: User role '${user.role}' is not in required roles ${JSON.stringify(roles)}`);
      throw new ForbiddenException('Forbidden resource: You do not have the required role to access this resource.');
    }
    return hasRole;
  }
}
