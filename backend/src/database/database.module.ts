import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useFactory: (configService: ConfigService) => {
        const host = configService.get<string>('MONGO_HOST');
        const port = configService.get<number>('MONGO_PORT');
        const username = configService.get<string>('MONGO_USERNAME');
        const password = configService.get<string>('MONGO_PASSWORD');
        const database = configService.get<string>('MONGO_DATABASE');
        const uri = `mongodb://${username}:${password}@${host}:${port}/${database}?authSource=admin`;

        return { uri };
      },
      inject: [ConfigService],
    }),
  ],
})
export class DatabaseModule {}
