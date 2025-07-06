import { Module } from '@nestjs/common';
import { AuhtService } from './auht.service';
import { AuhtController } from './auht.controller';

@Module({
  controllers: [AuhtController],
  providers: [AuhtService],
})
export class AuhtModule {}
