import { Injectable } from '@nestjs/common';
import postgres from '@prisma/orm-postgres/runtime';

import type { Contract } from '../../prisma/contract.js';

import contractJson from '../../prisma/contract.json';

@Injectable()
export class PrismaService {
  readonly db: ReturnType<typeof postgres<Contract>>;

  constructor() {
    const connectionString = process.env.DATABASE_URL;

    if (!connectionString) {
      throw new Error('DATABASE_URL is not configured');
    }

    this.db = postgres<Contract>({
      contractJson,
      url: connectionString,
    });
  }
}