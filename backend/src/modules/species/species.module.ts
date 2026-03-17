import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Species, SpeciesSchema } from './schemas/species.schema';
import { SpeciesService } from './species.service';
import { SpeciesController } from './species.controller';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Species.name, schema: SpeciesSchema }]),
  ],
  controllers: [SpeciesController],
  providers: [SpeciesService],
  exports: [SpeciesService],
})
export class SpeciesModule {}
