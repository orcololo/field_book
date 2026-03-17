import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { ApiProperty } from '@nestjs/swagger';

export type UserDocument = HydratedDocument<User>;

export enum UserRole {
  ADMIN = 'admin',
  RESEARCHER = 'researcher',
  COLLECTOR = 'collector',
}

@Schema({
  timestamps: true,
  toJSON: {
    virtuals: true,
    transform: (_doc: any, ret: any) => {
      ret.id = ret._id;
      delete ret._id;
      delete ret.__v;
      delete ret.password;
      return ret;
    },
  },
})
export class User {
  @ApiProperty({ example: 'João Silva' })
  @Prop({ required: true, trim: true })
  name: string;

  @ApiProperty({ example: 'joao@example.com' })
  @Prop({ required: true, unique: true, lowercase: true, trim: true })
  email: string;

  @Prop()
  password?: string;

  @ApiProperty({ example: '1234567890', required: false })
  @Prop({ sparse: true, unique: true })
  googleId?: string;

  @ApiProperty({ example: 'https://lh3.googleusercontent.com/photo.jpg', required: false })
  @Prop()
  avatar?: string;

  @ApiProperty({ enum: UserRole, example: UserRole.RESEARCHER })
  @Prop({ type: String, enum: UserRole, default: UserRole.COLLECTOR })
  role: UserRole;

  @ApiProperty({ example: 'Universidade Federal' })
  @Prop({ trim: true })
  institution?: string;

  @ApiProperty({ example: true })
  @Prop({ default: true })
  isActive: boolean;

  @Prop()
  refreshToken?: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.index({ name: 'text', institution: 'text' });
UserSchema.index({ googleId: 1 }, { sparse: true });
