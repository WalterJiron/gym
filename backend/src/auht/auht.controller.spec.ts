import { Test, TestingModule } from '@nestjs/testing';
import { AuhtController } from './auht.controller';
import { AuhtService } from './auht.service';

describe('AuhtController', () => {
  let controller: AuhtController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuhtController],
      providers: [AuhtService],
    }).compile();

    controller = module.get<AuhtController>(AuhtController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
