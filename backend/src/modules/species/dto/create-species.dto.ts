import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
} from 'class-validator';
import { PlantCategory } from '../enums/plant-category.enum';

export class CreateSpeciesDto {
  @ApiProperty({ example: 'Coffea arabica' })
  @IsString()
  @IsNotEmpty()
  scientificName: string;

  @ApiPropertyOptional({ example: 'Café' })
  @IsOptional()
  @IsString()
  commonName?: string;

  @ApiPropertyOptional({ example: 'Rubiaceae' })
  @IsOptional()
  @IsString()
  family?: string;

  @ApiPropertyOptional({ example: 'Coffea' })
  @IsOptional()
  @IsString()
  genus?: string;

  @ApiPropertyOptional({ example: 'arabica' })
  @IsOptional()
  @IsString()
  species?: string;

  @ApiPropertyOptional({ enum: PlantCategory })
  @IsOptional()
  @IsEnum(PlantCategory)
  category?: PlantCategory;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;
}
