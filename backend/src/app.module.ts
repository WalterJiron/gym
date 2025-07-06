import { Module } from '@nestjs/common';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { AuhtModule } from './auht/auht.module';

@Module({
  imports: [UsersModule, RolesModule, AuhtModule],
  controllers: [],
  providers: [],
})
export class AppModule { }
