import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsBoolean,
  IsDateString,
  IsEnum,
  IsArray,
  IsUUID,
  ValidateNested,
  Min,
  IsInt,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PlantCategory } from '../../species/enums/plant-category.enum';

// ── Embedded DTOs (reused from registry) ──

class SyncStemMorphologyDto {
  @IsOptional() @IsString() type?: string;
  @IsOptional() @IsString() color?: string;
  @IsOptional() @IsString() size?: string;
  @IsOptional() @IsString() circumference?: string;
  @IsOptional() @IsString() sap?: string;
}

class SyncLeafMorphologyDto {
  @IsOptional() @IsString() bainha?: string;
  @IsOptional() @IsString() peciolo?: string;
  @IsOptional() @IsString() lamina?: string;
}

class SyncFlowerMorphologyDto {
  @IsOptional() @IsString() inflorescence?: string;
  @IsOptional() @IsString() color?: string;
  @IsOptional() @IsString() size?: string;
}

class SyncFruitMorphologyDto {
  @IsOptional() @IsString() color?: string;
  @IsOptional() @IsString() format?: string;
  @IsOptional() @IsString() size?: string;
}

class SyncSeedMorphologyDto {
  @IsOptional() @IsString() format?: string;
  @IsOptional() @IsString() size?: string;
}

class SyncMorphologyDto {
  @IsOptional() @IsString() root?: string;
  @IsOptional() @ValidateNested() @Type(() => SyncStemMorphologyDto) stem?: SyncStemMorphologyDto;
  @IsOptional() @ValidateNested() @Type(() => SyncLeafMorphologyDto) leaf?: SyncLeafMorphologyDto;
  @IsOptional() @ValidateNested() @Type(() => SyncFlowerMorphologyDto) flower?: SyncFlowerMorphologyDto;
  @IsOptional() @ValidateNested() @Type(() => SyncFruitMorphologyDto) fruit?: SyncFruitMorphologyDto;
  @IsOptional() @ValidateNested() @Type(() => SyncSeedMorphologyDto) seed?: SyncSeedMorphologyDto;
}

class SyncMeasurementDto {
  @IsString() @IsNotEmpty() label: string;
  @IsNumber() value: number;
  @IsOptional() @IsString() unit?: string;
}

class SyncPhotoMetadataDto {
  @IsOptional() @IsString() exifDataJson?: string;
  @IsOptional() @IsDateString() dateTaken?: string;
  @IsOptional() @IsNumber() latitude?: number;
  @IsOptional() @IsNumber() longitude?: number;
  @IsOptional() @IsNumber() fileSize?: number;
}

// ── Sync item: a single registry record from the client ──

export class SyncRegistryItemDto {
  @ApiProperty({ description: 'Client-generated v4 UUID' })
  @IsUUID('4')
  uuid: string;

  @ApiProperty({ example: 'RC000001' })
  @IsString()
  @IsNotEmpty()
  registryIdentifier: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  scientificName: string;

  @ApiPropertyOptional() @IsOptional() @IsString() commonName?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() family?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() genus?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() speciesEpithet?: string;

  @ApiPropertyOptional({ enum: PlantCategory })
  @IsOptional()
  @IsEnum(PlantCategory)
  category?: PlantCategory;

  @ApiPropertyOptional() @IsOptional() @IsString() sessionId?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() latitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() longitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsDateString() dateCollected?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() habitat?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @ValidateNested()
  @Type(() => SyncMorphologyDto)
  morphology?: SyncMorphologyDto;

  @ApiPropertyOptional({ type: [SyncMeasurementDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SyncMeasurementDto)
  measurements?: SyncMeasurementDto[];

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  audioTranscripts?: string[];

  @ApiPropertyOptional({ type: [SyncPhotoMetadataDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SyncPhotoMetadataDto)
  photoMetadata?: SyncPhotoMetadataDto[];

  @ApiPropertyOptional() @IsOptional() @IsString() notes?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() contributorName?: string;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() isDraft?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsString() deviceId?: string;

  @ApiProperty({ description: 'Client sync version for conflict detection' })
  @IsNumber()
  @Min(0)
  syncVersion: number;

  @ApiPropertyOptional({ description: 'Timestamp of last local modification' })
  @IsOptional()
  @IsDateString()
  localModifiedAt?: string;
}

// ── Sync item: a single session from the client ──

export class SyncSessionItemDto {
  @ApiProperty({ description: 'Client-generated v4 UUID' })
  @IsUUID('4')
  uuid: string;

  @ApiProperty() @IsString() @IsNotEmpty() tripName: string;
  @ApiProperty() @IsDateString() startDate: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() endDate?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() location?: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  teamMembers?: string[];

  @ApiPropertyOptional() @IsOptional() @IsString() shareCode?: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  sharedWith?: string[];

  @ApiPropertyOptional() @IsOptional() @IsString() notes?: string;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() isArchived?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsString() deviceId?: string;

  @ApiProperty({ description: 'Client sync version for conflict detection' })
  @IsNumber()
  @Min(0)
  syncVersion: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  localModifiedAt?: string;
}

// ── Push request: batch of changes from client ──

export class SyncPushDto {
  @ApiPropertyOptional({ type: [SyncRegistryItemDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SyncRegistryItemDto)
  registries?: SyncRegistryItemDto[];

  @ApiPropertyOptional({ type: [SyncSessionItemDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SyncSessionItemDto)
  sessions?: SyncSessionItemDto[];

  @ApiProperty({ description: 'Device ID sending the sync' })
  @IsString()
  @IsNotEmpty()
  deviceId: string;
}

// ── Pull request: query for server changes ──

export class SyncPullDto {
  @ApiPropertyOptional({ description: 'ISO timestamp — pull changes since this time' })
  @IsOptional()
  @IsDateString()
  since?: string;

  @ApiPropertyOptional({ default: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number;
}
