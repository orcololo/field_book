import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export type RegistryDocument = HydratedDocument<Registry>;

// ── Embedded subdocument schemas ──

@Schema({ _id: false })
export class ImageRef {
  @ApiProperty({ example: 'images/userId/registryId/uuid.jpg' })
  @Prop({ required: true })
  key: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/images/...' })
  @Prop()
  url: string;

  @ApiProperty({ example: 'thumbnails/userId/uuid.jpg' })
  @Prop({ required: true })
  thumbnailKey: string;

  @ApiProperty({ example: 'https://pub-xxx.r2.dev/thumbnails/...' })
  @Prop()
  thumbnailUrl: string;
}

@Schema({ _id: false })
export class Measurement {
  @ApiProperty({ example: 'Altura' })
  @Prop({ required: true })
  label: string;

  @ApiProperty({ example: 2.5 })
  @Prop({ required: true })
  value: number;

  @ApiPropertyOptional({ example: 'm' })
  @Prop()
  unit: string;
}

@Schema({ _id: false })
export class StemMorphology {
  @ApiPropertyOptional() @Prop()
  type?: string;

  @ApiPropertyOptional() @Prop()
  color?: string;

  @ApiPropertyOptional() @Prop()
  size?: string;

  @ApiPropertyOptional() @Prop()
  circumference?: string;

  @ApiPropertyOptional() @Prop()
  sap?: string;
}

@Schema({ _id: false })
export class LeafMorphology {
  @ApiPropertyOptional() @Prop()
  bainha?: string;

  @ApiPropertyOptional() @Prop()
  peciolo?: string;

  @ApiPropertyOptional() @Prop()
  lamina?: string;
}

@Schema({ _id: false })
export class FlowerMorphology {
  @ApiPropertyOptional() @Prop()
  inflorescence?: string;

  @ApiPropertyOptional() @Prop()
  color?: string;

  @ApiPropertyOptional() @Prop()
  size?: string;
}

@Schema({ _id: false })
export class FruitMorphology {
  @ApiPropertyOptional() @Prop()
  color?: string;

  @ApiPropertyOptional() @Prop()
  format?: string;

  @ApiPropertyOptional() @Prop()
  size?: string;
}

@Schema({ _id: false })
export class SeedMorphology {
  @ApiPropertyOptional() @Prop()
  format?: string;

  @ApiPropertyOptional() @Prop()
  size?: string;
}

@Schema({ _id: false })
export class Morphology {
  @ApiPropertyOptional() @Prop()
  root?: string;

  @ApiPropertyOptional({ type: StemMorphology }) @Prop({ type: StemMorphology })
  stem?: StemMorphology;

  @ApiPropertyOptional({ type: LeafMorphology }) @Prop({ type: LeafMorphology })
  leaf?: LeafMorphology;

  @ApiPropertyOptional({ type: FlowerMorphology }) @Prop({ type: FlowerMorphology })
  flower?: FlowerMorphology;

  @ApiPropertyOptional({ type: FruitMorphology }) @Prop({ type: FruitMorphology })
  fruit?: FruitMorphology;

  @ApiPropertyOptional({ type: SeedMorphology }) @Prop({ type: SeedMorphology })
  seed?: SeedMorphology;
}

@Schema({ _id: false })
export class PhotoMetadata {
  @ApiPropertyOptional({ description: 'EXIF data as JSON string' })
  @Prop({ default: '{}' })
  exifDataJson: string;

  @ApiPropertyOptional() @Prop()
  dateTaken?: Date;

  @ApiPropertyOptional() @Prop()
  latitude?: number;

  @ApiPropertyOptional() @Prop()
  longitude?: number;

  @ApiPropertyOptional() @Prop({ default: 0 })
  fileSize: number;
}

@Schema({ _id: false })
export class SyncMetadata {
  @ApiPropertyOptional() @Prop()
  deviceId?: string;

  @ApiPropertyOptional() @Prop()
  lastSyncedAt?: Date;

  @ApiPropertyOptional() @Prop()
  localModifiedAt?: Date;

  @ApiPropertyOptional({ description: 'Conflicting data stored for manual resolution' })
  @Prop()
  conflictData?: string;

  @ApiPropertyOptional({ enum: ['pending', 'synced', 'conflict', 'error'], default: 'pending' })
  @Prop({ type: String, default: 'pending' })
  syncStatus: string;

  @ApiPropertyOptional({ description: 'Hash of last pushed data for change detection' })
  @Prop()
  lastPushedHash?: string;

  @ApiPropertyOptional({ description: 'Incrementing version for conflict resolution' })
  @Prop({ default: 0 })
  syncVersion: number;
}

// ── Main Registry schema ──

@Schema({
  timestamps: true,
  toJSON: {
    virtuals: true,
    transform: (_doc: any, ret: any) => {
      ret.id = ret._id;
      delete ret._id;
      delete ret.__v;
      return ret;
    },
  },
})
export class Registry {
  @ApiProperty({ description: 'Client-generated UUID for sync identity' })
  @Prop({ required: true, unique: true, index: true })
  uuid: string;

  @ApiProperty({ example: 'RC000001' })
  @Prop({ required: true, unique: true, trim: true })
  registryIdentifier: string;

  @ApiProperty({ description: 'Reference to Species' })
  @Prop({ type: Types.ObjectId, ref: 'Species', required: true, index: true })
  species: Types.ObjectId;

  @ApiProperty({ description: 'User who collected this specimen' })
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  collector: Types.ObjectId;

  @ApiPropertyOptional({ description: 'Flutter CollectionSession UUID' })
  @Prop({ index: true })
  sessionId?: string;

  @ApiPropertyOptional()
  @Prop()
  latitude?: number;

  @ApiPropertyOptional()
  @Prop()
  longitude?: number;

  @ApiPropertyOptional()
  @Prop()
  dateCollected?: Date;

  @ApiPropertyOptional()
  @Prop()
  habitat?: string;

  @ApiPropertyOptional({ type: Morphology })
  @Prop({ type: Morphology })
  morphology?: Morphology;

  @ApiProperty({ type: [Measurement] })
  @Prop({ type: [Measurement], default: [] })
  measurements: Measurement[];

  @ApiProperty({ type: [ImageRef] })
  @Prop({ type: [ImageRef], default: [] })
  images: ImageRef[];

  @ApiProperty({ type: [String] })
  @Prop({ type: [String], default: [] })
  audioNotes: string[];

  @ApiProperty({ type: [String], default: [] })
  @Prop({ type: [String], default: [] })
  audioTranscripts: string[];

  @ApiProperty({ type: [PhotoMetadata], default: [] })
  @Prop({ type: [PhotoMetadata], default: [] })
  photoMetadata: PhotoMetadata[];

  @ApiPropertyOptional()
  @Prop()
  notes?: string;

  @ApiPropertyOptional()
  @Prop()
  contributorName?: string;

  @ApiProperty({ default: true })
  @Prop({ default: true })
  isDraft: boolean;

  @ApiPropertyOptional({ type: SyncMetadata })
  @Prop({ type: SyncMetadata })
  syncMetadata?: SyncMetadata;

  @ApiProperty({ default: true })
  @Prop({ default: true })
  isActive: boolean;
}

export const RegistrySchema = SchemaFactory.createForClass(Registry);

RegistrySchema.index({ collector: 1, sessionId: 1 });
RegistrySchema.index({ registryIdentifier: 'text' });
RegistrySchema.index({ 'syncMetadata.syncStatus': 1 });
RegistrySchema.index({ updatedAt: 1 });
