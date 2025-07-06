import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { AuhtService } from './auht.service';
import { CreateAuhtDto } from './dto/create-auht.dto';
import { UpdateAuhtDto } from './dto/update-auht.dto';

@Controller('auht')
export class AuhtController {
  constructor(private readonly auhtService: AuhtService) {}

  @Post()
  create(@Body() createAuhtDto: CreateAuhtDto) {
    return this.auhtService.create(createAuhtDto);
  }

  @Get()
  findAll() {
    return this.auhtService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.auhtService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateAuhtDto: UpdateAuhtDto) {
    return this.auhtService.update(+id, updateAuhtDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.auhtService.remove(+id);
  }
}
