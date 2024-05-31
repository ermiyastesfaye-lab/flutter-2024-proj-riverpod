import { ForbiddenException, Injectable } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.service";
import { AuthDto } from "./dto";
import * as argon from 'argon2';
import { JwtService } from "@nestjs/jwt";
import { ConfigService } from "@nestjs/config";

import { Role } from "@prisma/client";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";

@Injectable()
export class AuthService {
    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
        private configService: ConfigService
    ) {}

    async signup(dto: AuthDto) {
        const hash = await argon.hash(dto.password);
        try {
            const userRole = dto.role === 'FARMER' ? Role.FARMER : Role.BUYER;  // Convert string to Role enum value
            const user = await this.prisma.user.create({
                data: {
                    email: dto.email,
                    role: userRole,
                    hash: hash
                }
            });

            return this.signToken(user.id, user.email, user.role);
        } catch (error) {
            if (error instanceof PrismaClientKnownRequestError && error.code === 'P2002') {
                throw new ForbiddenException('Credentials already taken');
            }
            throw error;
        }
    }

    async signin(dto: AuthDto) {
        const user = await this.prisma.user.findFirst({
            where: {
                email: dto.email,
            }
        });

        if (!user) {
            throw new ForbiddenException('Credentials incorrect');
        }

        const pwMatches = await argon.verify(user.hash, dto.password);
        if (!pwMatches) {
            throw new ForbiddenException('Credentials incorrect');
        }

        return this.signToken(user.id, user.email, user.role);
    }

    async signToken(userId: number, email: string, role: string): Promise<{ access_token: string, userId: number }> {
        const payload = { sub: userId, email, role };
        const secret = this.configService.get('JWT_SECRET');
        const token = await this.jwtService.signAsync(payload, {
          expiresIn: '60m',
          secret: secret,
        });
        return {
          access_token: token,
          userId: userId,
        };
    }
}
