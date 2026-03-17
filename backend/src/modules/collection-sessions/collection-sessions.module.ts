import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import {
  CollectionSession,
  CollectionSessionSchema,
} from './schemas/collection-session.schema';
import { CollectionSessionsService } from './collection-sessions.service';
import { CollectionSessionsController } from './collection-sessions.controller';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: CollectionSession.name, schema: CollectionSessionSchema },
    ]),
  ],
  controllers: [CollectionSessionsController],
  providers: [CollectionSessionsService],
  exports: [CollectionSessionsService],
})
export class CollectionSessionsModule {}
