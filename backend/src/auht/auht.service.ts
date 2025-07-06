import { Injectable } from '@nestjs/common';
import { CreateAuhtDto } from './dto/create-auht.dto';
import { UpdateAuhtDto } from './dto/update-auht.dto';

@Injectable()
export class AuhtService {
  create(createAuhtDto: CreateAuhtDto) {
    return 'This action adds a new auht';
  }

  findAll() {
    return `This action returns all auht`;
  }

  findOne(id: number) {
    return `This action returns a #${id} auht`;
  }

  update(id: number, updateAuhtDto: UpdateAuhtDto) {
    return `This action updates a #${id} auht`;
  }

  remove(id: number) {
    return `This action removes a #${id} auht`;
  }
}
