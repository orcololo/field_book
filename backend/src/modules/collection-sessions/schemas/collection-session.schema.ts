import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SyncMetadata } from '../../registry/schemas/registry.schema';

export type CollectionSessionDocument = HydratedDocument<CollectionSession>;

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
export class CollectionSession {
  @ApiProperty({ description: 'Client-generated UUID for sync identity' })
  @Prop({ required: true, unique: true, index: true })
  uuid: string;

  @ApiProperty({ example: 'Amazonia Trip 2026' })
  @Prop({ required: true, trim: true })
  tripName: string;

  @ApiProperty()
  @Prop({ required: true })
  startDate: Date;

  @ApiPropertyOptional()
  @Prop()
  endDate?: Date;

  @ApiPropertyOptional()
  @Prop({ trim: true })
  location?: string;

  @ApiProperty({ type: [String] })
  @Prop({ type: [String], default: [] })
  teamMembers: string[];

  @ApiPropertyOptional()
  @Prop({ unique: true, sparse: true })
  shareCode?: string;

  @ApiProperty({ type: [String], description: 'Device IDs that have access' })
  @Prop({ type: [String], default: [] })
  sharedWith: string[];

  @ApiPropertyOptional()
  @Prop()
  notes?: string;

  @ApiProperty({ default: false })
  @Prop({ default: false })
  isArchived: boolean;

  @ApiProperty({ description: 'User who created this session' })
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  owner: Types.ObjectId;

  @ApiPropertyOptional({ type: SyncMetadata })
  @Prop({ type: SyncMetadata })
  syncMetadata?: SyncMetadata;

  @ApiProperty({ default: true })
  @Prop({ default: true })
  isActive: boolean;
}

export const CollectionSessionSchema = SchemaFactory.createForClass(CollectionSession);

CollectionSessionSchema.index({ tripName: 'text', location: 'text' });
CollectionSessionSchema.index({ owner: 1, isArchived: 1 });
CollectionSessionSchema.index({ 'syncMetadata.syncStatus': 1 });
CollectionSessionSchema.index({ updatedAt: 1 });
