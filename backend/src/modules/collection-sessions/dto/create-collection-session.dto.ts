import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsDateString,
  IsArray,
  IsBoolean,
  IsUUID,
} from 'class-validator';

export class CreateCollectionSessionDto {
  @ApiProperty({ description: 'Client-generated v4 UUID for sync identity' })
  @IsUUID('4')
  uuid: string;

  @ApiProperty({ example: 'Amazonia Trip 2026' })
  @IsString()
  @IsNotEmpty()
  tripName: string;

  @ApiProperty()
  @IsDateString()
  startDate: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  location?: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  teamMembers?: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  shareCode?: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  sharedWith?: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  isArchived?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;
}
