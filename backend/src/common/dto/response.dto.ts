import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

// ── Auth responses ──

export class TokenResponseDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  accessToken: string;

  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  refreshToken: string;
}

// ── Upload responses ──

export class UploadResultDto {
  @ApiProperty({ example: 'images/userId/registryId/uuid.jpg' })
  key: string;

  @ApiProperty({ example: 'thumbnails/userId/uuid.jpg' })
  thumbnailKey: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/images/userId/registryId/uuid.jpg' })
  url: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/thumbnails/userId/uuid.jpg' })
  thumbnailUrl: string;
}

// ── Generic responses ──

export class DeleteResponseDto {
  @ApiProperty({ example: true })
  deleted: boolean;
}

export class PaginationMetaDto {
  @ApiProperty({ example: 42 })
  total: number;

  @ApiProperty({ example: 1 })
  page: number;

  @ApiProperty({ example: 20 })
  limit: number;

  @ApiProperty({ example: 3 })
  totalPages: number;
}

// ── Image ref (for registry responses) ──

export class ImageRefDto {
  @ApiProperty({ example: 'images/userId/registryId/uuid.jpg' })
  key: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/images/...' })
  url: string;

  @ApiProperty({ example: 'thumbnails/userId/uuid.jpg' })
  thumbnailKey: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/thumbnails/...' })
  thumbnailUrl: string;
}

export class MeasurementResponseDto {
  @ApiProperty({ example: 'Altura' })
  label: string;

  @ApiProperty({ example: 2.5 })
  value: number;

  @ApiPropertyOptional({ example: 'm' })
  unit?: string;
}

// ── Morphology response ──

export class StemMorphologyResponseDto {
  @ApiPropertyOptional() type?: string;
  @ApiPropertyOptional() color?: string;
  @ApiPropertyOptional() size?: string;
  @ApiPropertyOptional() circumference?: string;
  @ApiPropertyOptional() sap?: string;
}

export class LeafMorphologyResponseDto {
  @ApiPropertyOptional() bainha?: string;
  @ApiPropertyOptional() peciolo?: string;
  @ApiPropertyOptional() lamina?: string;
}

export class FlowerMorphologyResponseDto {
  @ApiPropertyOptional() inflorescence?: string;
  @ApiPropertyOptional() color?: string;
  @ApiPropertyOptional() size?: string;
}

export class FruitMorphologyResponseDto {
  @ApiPropertyOptional() color?: string;
  @ApiPropertyOptional() format?: string;
  @ApiPropertyOptional() size?: string;
}

export class SeedMorphologyResponseDto {
  @ApiPropertyOptional() format?: string;
  @ApiPropertyOptional() size?: string;
}

export class MorphologyResponseDto {
  @ApiPropertyOptional() root?: string;
  @ApiPropertyOptional({ type: StemMorphologyResponseDto }) stem?: StemMorphologyResponseDto;
  @ApiPropertyOptional({ type: LeafMorphologyResponseDto }) leaf?: LeafMorphologyResponseDto;
  @ApiPropertyOptional({ type: FlowerMorphologyResponseDto }) flower?: FlowerMorphologyResponseDto;
  @ApiPropertyOptional({ type: FruitMorphologyResponseDto }) fruit?: FruitMorphologyResponseDto;
  @ApiPropertyOptional({ type: SeedMorphologyResponseDto }) seed?: SeedMorphologyResponseDto;
}

export class SyncMetadataResponseDto {
  @ApiPropertyOptional() deviceId?: string;
  @ApiPropertyOptional() lastSyncedAt?: Date;
  @ApiPropertyOptional() localModifiedAt?: Date;
  @ApiPropertyOptional() conflictData?: string;
  @ApiPropertyOptional({ enum: ['pending', 'synced', 'conflict', 'error'] }) syncStatus?: string;
  @ApiPropertyOptional() lastPushedHash?: string;
  @ApiPropertyOptional() syncVersion?: number;
}

export class PhotoMetadataResponseDto {
  @ApiPropertyOptional() exifDataJson?: string;
  @ApiPropertyOptional() dateTaken?: Date;
  @ApiPropertyOptional() latitude?: number;
  @ApiPropertyOptional() longitude?: number;
  @ApiPropertyOptional() fileSize?: number;
}

// ── Species response ──

export class SpeciesResponseDto {
  @ApiProperty({ example: '507f1f77bcf86cd799439011' })
  id: string;

  @ApiProperty({ example: 'Coffea arabica' })
  scientificName: string;

  @ApiPropertyOptional({ example: 'Café' })
  commonName?: string;

  @ApiPropertyOptional({ example: 'Rubiaceae' })
  family?: string;

  @ApiPropertyOptional({ example: 'Coffea' })
  genus?: string;

  @ApiPropertyOptional({ example: 'arabica' })
  species?: string;

  @ApiPropertyOptional({ example: 'trees' })
  category?: string;

  @ApiPropertyOptional()
  description?: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class PaginatedSpeciesResponseDto {
  @ApiProperty({ type: [SpeciesResponseDto] })
  data: SpeciesResponseDto[];

  @ApiProperty({ type: PaginationMetaDto })
  meta: PaginationMetaDto;
}

// ── User response ──

export class UserResponseDto {
  @ApiProperty({ example: '507f1f77bcf86cd799439011' })
  id: string;

  @ApiProperty({ example: 'João Silva' })
  name: string;

  @ApiProperty({ example: 'joao@example.com' })
  email: string;

  @ApiProperty({ example: 'collector', enum: ['admin', 'researcher', 'collector'] })
  role: string;

  @ApiPropertyOptional({ example: 'Universidade Federal' })
  institution?: string;

  @ApiPropertyOptional({ example: 'https://lh3.googleusercontent.com/photo.jpg' })
  avatar?: string;

  @ApiProperty({ example: true })
  isActive: boolean;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class PaginatedUsersResponseDto {
  @ApiProperty({ type: [UserResponseDto] })
  data: UserResponseDto[];

  @ApiProperty({ type: PaginationMetaDto })
  meta: PaginationMetaDto;
}

// ── Registry response ──

export class RegistryResponseDto {
  @ApiProperty({ example: '507f1f77bcf86cd799439011' })
  id: string;

  @ApiProperty({ description: 'Client-generated UUID for sync' })
  uuid: string;

  @ApiProperty({ example: 'RC000001' })
  registryIdentifier: string;

  @ApiProperty({ type: SpeciesResponseDto, description: 'Populated species data' })
  species: SpeciesResponseDto;

  @ApiProperty({ description: 'Collector user info' })
  collector: Pick<UserResponseDto, 'id' | 'name' | 'email'>;

  @ApiPropertyOptional({ description: 'Flutter CollectionSession UUID' })
  sessionId?: string;

  @ApiPropertyOptional({ example: -22.9068 })
  latitude?: number;

  @ApiPropertyOptional({ example: -43.1729 })
  longitude?: number;

  @ApiPropertyOptional()
  dateCollected?: Date;

  @ApiPropertyOptional()
  habitat?: string;

  @ApiPropertyOptional({ type: MorphologyResponseDto })
  morphology?: MorphologyResponseDto;

  @ApiProperty({ type: [MeasurementResponseDto] })
  measurements: MeasurementResponseDto[];

  @ApiProperty({ type: [ImageRefDto] })
  images: ImageRefDto[];

  @ApiProperty({ type: [String] })
  audioNotes: string[];

  @ApiProperty({ type: [String] })
  audioTranscripts: string[];

  @ApiProperty({ type: [PhotoMetadataResponseDto] })
  photoMetadata: PhotoMetadataResponseDto[];

  @ApiPropertyOptional()
  notes?: string;

  @ApiPropertyOptional()
  contributorName?: string;

  @ApiProperty({ example: true })
  isDraft: boolean;

  @ApiPropertyOptional({ type: SyncMetadataResponseDto })
  syncMetadata?: SyncMetadataResponseDto;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class PaginatedRegistriesResponseDto {
  @ApiProperty({ type: [RegistryResponseDto] })
  data: RegistryResponseDto[];

  @ApiProperty({ type: PaginationMetaDto })
  meta: PaginationMetaDto;
}

// ── CollectionSession response ──

export class CollectionSessionResponseDto {
  @ApiProperty({ example: '507f1f77bcf86cd799439011' })
  id: string;

  @ApiProperty({ description: 'Client-generated UUID for sync' })
  uuid: string;

  @ApiProperty({ example: 'Amazonia Trip 2026' })
  tripName: string;

  @ApiProperty()
  startDate: Date;

  @ApiPropertyOptional()
  endDate?: Date;

  @ApiPropertyOptional()
  location?: string;

  @ApiProperty({ type: [String] })
  teamMembers: string[];

  @ApiPropertyOptional()
  shareCode?: string;

  @ApiProperty({ type: [String] })
  sharedWith: string[];

  @ApiPropertyOptional()
  notes?: string;

  @ApiProperty({ example: false })
  isArchived: boolean;

  @ApiPropertyOptional({ type: SyncMetadataResponseDto })
  syncMetadata?: SyncMetadataResponseDto;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class PaginatedSessionsResponseDto {
  @ApiProperty({ type: [CollectionSessionResponseDto] })
  data: CollectionSessionResponseDto[];

  @ApiProperty({ type: PaginationMetaDto })
  meta: PaginationMetaDto;
}
