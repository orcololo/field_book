import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsEnum, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { PlantCategory } from '../enums/plant-category.enum';

export class QuerySpeciesDto {
  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number;

  @ApiPropertyOptional({ description: 'Full-text search on name/family' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ enum: PlantCategory })
  @IsOptional()
  @IsEnum(PlantCategory)
  category?: PlantCategory;

  @ApiPropertyOptional({ example: 'Rubiaceae' })
  @IsOptional()
  @IsString()
  family?: string;

  @ApiPropertyOptional({ default: 'scientificName', enum: ['scientificName', 'family', 'createdAt'] })
  @IsOptional()
  @IsString()
  sortBy?: string;

  @ApiPropertyOptional({ default: 'asc', enum: ['asc', 'desc'] })
  @IsOptional()
  @IsString()
  sortOrder?: string;
}
