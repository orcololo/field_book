import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Registry, RegistrySchema } from '../registry/schemas/registry.schema';
import {
  CollectionSession,
  CollectionSessionSchema,
} from '../collection-sessions/schemas/collection-session.schema';
import { SpeciesModule } from '../species/species.module';
import { SyncService } from './sync.service';
import { SyncController } from './sync.controller';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Registry.name, schema: RegistrySchema },
      { name: CollectionSession.name, schema: CollectionSessionSchema },
    ]),
    SpeciesModule,
  ],
  controllers: [SyncController],
  providers: [SyncService],
})
export class SyncModule {}
