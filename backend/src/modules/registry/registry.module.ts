import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Registry, RegistrySchema } from './schemas/registry.schema';
import { RegistryService } from './registry.service';
import { RegistryController } from './registry.controller';
import { SpeciesModule } from '../species/species.module';
import { UploadModule } from '../upload/upload.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Registry.name, schema: RegistrySchema }]),
    SpeciesModule,
    UploadModule,
  ],
  controllers: [RegistryController],
  providers: [RegistryService],
  exports: [RegistryService],
})
export class RegistryModule {}
