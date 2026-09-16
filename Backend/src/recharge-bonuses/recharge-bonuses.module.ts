import { Module } from '@nestjs/common';

import { RechargeBonusesController } from './recharge-bonuses.controller';
import { RechargeBonusesService } from './recharge-bonuses.service';

@Module({
  controllers: [RechargeBonusesController],
  providers: [RechargeBonusesService],
  exports: [RechargeBonusesService],
})
export class RechargeBonusesModule {}
