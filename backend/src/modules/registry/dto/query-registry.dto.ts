import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsInt, Min, IsBoolean } from 'class-validator';
import { Type, Transform } from 'class-transformer';

export class QueryRegistryDto {
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

  @ApiPropertyOptional({ description: 'Filter by collector. Use "me" for current user, or a user ObjectId.' })
  @IsOptional()
  @IsString()
  collector?: string;

  @ApiPropertyOptional({ description: 'Filter by Flutter session UUID' })
  @IsOptional()
  @IsString()
  sessionId?: string;

  @ApiPropertyOptional({ description: 'Filter by species ObjectId' })
  @IsOptional()
  @IsString()
  speciesId?: string;

  @ApiPropertyOptional({ description: 'Filter drafts only' })
  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  isDraft?: boolean;

  @ApiPropertyOptional({ description: 'Full-text search on registryIdentifier' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ default: 'createdAt', enum: ['createdAt', 'dateCollected', 'registryIdentifier'] })
  @IsOptional()
  @IsString()
  sortBy?: string;

  @ApiPropertyOptional({ default: 'desc', enum: ['asc', 'desc'] })
  @IsOptional()
  @IsString()
  sortOrder?: string;
}
