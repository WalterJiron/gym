import { PartialType } from '@nestjs/mapped-types';
import { CreateAuhtDto } from './create-auht.dto';

export class UpdateAuhtDto extends PartialType(CreateAuhtDto) {}
