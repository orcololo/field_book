import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsBoolean,
  IsDateString,
  IsEnum,
  ValidateNested,
  IsArray,
  IsUUID,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PlantCategory } from '../../species/enums/plant-category.enum';

class StemMorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() type?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() color?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() size?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() circumference?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() sap?: string;
}

class LeafMorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() bainha?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() peciolo?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() lamina?: string;
}

class FlowerMorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() inflorescence?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() color?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() size?: string;
}

class FruitMorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() color?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() format?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() size?: string;
}

class SeedMorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() format?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() size?: string;
}

class MorphologyDto {
  @ApiPropertyOptional() @IsOptional() @IsString() root?: string;

  @ApiPropertyOptional({ type: StemMorphologyDto }) @IsOptional() @ValidateNested() @Type(() => StemMorphologyDto)
  stem?: StemMorphologyDto;

  @ApiPropertyOptional({ type: LeafMorphologyDto }) @IsOptional() @ValidateNested() @Type(() => LeafMorphologyDto)
  leaf?: LeafMorphologyDto;

  @ApiPropertyOptional({ type: FlowerMorphologyDto }) @IsOptional() @ValidateNested() @Type(() => FlowerMorphologyDto)
  flower?: FlowerMorphologyDto;

  @ApiPropertyOptional({ type: FruitMorphologyDto }) @IsOptional() @ValidateNested() @Type(() => FruitMorphologyDto)
  fruit?: FruitMorphologyDto;

  @ApiPropertyOptional({ type: SeedMorphologyDto }) @IsOptional() @ValidateNested() @Type(() => SeedMorphologyDto)
  seed?: SeedMorphologyDto;
}

class MeasurementDto {
  @ApiProperty() @IsString() @IsNotEmpty() label: string;
  @ApiProperty() @IsNumber() value: number;
  @ApiPropertyOptional() @IsOptional() @IsString() unit?: string;
}

class PhotoMetadataDto {
  @ApiPropertyOptional({ description: 'EXIF data as JSON string' })
  @IsOptional() @IsString() exifDataJson?: string;

  @ApiPropertyOptional() @IsOptional() @IsDateString() dateTaken?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() latitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() longitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() fileSize?: number;
}

export class CreateRegistryDto {
  @ApiProperty({ description: 'Client-generated v4 UUID for sync identity' })
  @IsUUID('4')
  uuid: string;

  @ApiProperty({ example: 'RC000001' })
  @IsString()
  @IsNotEmpty()
  registryIdentifier: string;

  @ApiProperty({ example: 'Coffea arabica', description: 'Scientific name — auto-links or creates species' })
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
  speciesEpithet?: string;

  @ApiPropertyOptional({ enum: PlantCategory })
  @IsOptional()
  @IsEnum(PlantCategory)
  category?: PlantCategory;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  sessionId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  longitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  dateCollected?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  habitat?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @ValidateNested()
  @Type(() => MorphologyDto)
  morphology?: MorphologyDto;

  @ApiPropertyOptional({ type: [MeasurementDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => MeasurementDto)
  measurements?: MeasurementDto[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  audioTranscripts?: string[];

  @ApiPropertyOptional({ type: [PhotoMetadataDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PhotoMetadataDto)
  photoMetadata?: PhotoMetadataDto[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  contributorName?: string;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  isDraft?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;
}
