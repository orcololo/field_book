import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PlantCategory } from '../enums/plant-category.enum';

export type SpeciesDocument = HydratedDocument<Species>;

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
export class Species {
  @ApiProperty({ example: 'Coffea arabica' })
  @Prop({ required: true, unique: true, trim: true, index: true })
  scientificName: string;

  @Prop({ trim: true, lowercase: true })
  scientificNameLower: string;

  @ApiPropertyOptional({ example: 'Café' })
  @Prop({ trim: true })
  commonName?: string;

  @ApiPropertyOptional({ example: 'Rubiaceae' })
  @Prop({ trim: true })
  family?: string;

  @ApiPropertyOptional({ example: 'Coffea' })
  @Prop({ trim: true })
  genus?: string;

  @ApiPropertyOptional({ example: 'arabica' })
  @Prop({ trim: true })
  species?: string;

  @ApiPropertyOptional({ enum: PlantCategory })
  @Prop({ type: String, enum: PlantCategory })
  category?: PlantCategory;

  @ApiPropertyOptional()
  @Prop({ trim: true })
  description?: string;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  createdBy: Types.ObjectId;

  @ApiProperty({ example: true })
  @Prop({ default: true })
  isActive: boolean;
}

export const SpeciesSchema = SchemaFactory.createForClass(Species);

SpeciesSchema.index({ scientificNameLower: 1 }, { unique: true });
SpeciesSchema.index(
  { scientificName: 'text', commonName: 'text', family: 'text' },
  { weights: { scientificName: 3, commonName: 2, family: 1 } },
);

SpeciesSchema.pre('save', function () {
  if (this.isModified('scientificName')) {
    this.scientificNameLower = this.scientificName.toLowerCase().trim();
  }
});

SpeciesSchema.pre('findOneAndUpdate', function () {
  const update = this.getUpdate() as any;
  if (update?.$set?.scientificName) {
    update.$set.scientificNameLower = update.$set.scientificName.toLowerCase().trim();
  }
});
