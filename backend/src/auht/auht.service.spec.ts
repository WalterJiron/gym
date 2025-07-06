import { Test, TestingModule } from '@nestjs/testing';
import { AuhtService } from './auht.service';

describe('AuhtService', () => {
  let service: AuhtService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [AuhtService],
    }).compile();

    service = module.get<AuhtService>(AuhtService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
