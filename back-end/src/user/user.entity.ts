import { Role } from '@prisma/client';

export class User {
  id: number;
  email: string;
  role: Role;
  hash: string;
  createdAt: Date;
  updatedAt: Date;
}