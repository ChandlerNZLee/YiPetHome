import { Module } from '@nestjs/common';

import { OperationRecordsController } from './operation-records/operation-records.controller';
import { OperationRecordsService } from './operation-records/operation-records.service';
import { RechargeRecordsController } from './recharge-records/recharge-records.controller';
import { RechargeRecordsService } from './recharge-records/recharge-records.service';
import { SpendRecordsController } from './spend-records/spend-records.controller';
import { SpendRecordsService } from './spend-records/spend-records.service';
import { StockRecordsController } from './stock-records/stock-records.controller';
import { StockRecordsService } from './stock-records/stock-records.service';

@Module({
  controllers: [OperationRecordsController, RechargeRecordsController, SpendRecordsController, StockRecordsController],
  providers: [OperationRecordsService, RechargeRecordsService, SpendRecordsService, StockRecordsService],
  exports: [OperationRecordsService, RechargeRecordsService, SpendRecordsService, StockRecordsService],
})
export class RecordsModule {}
