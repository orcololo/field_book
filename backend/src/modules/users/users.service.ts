import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, FilterQuery } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto, UpdateUserDto, QueryUserDto } from './dto';

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private readonly userModel: Model<UserDocument>) {}

  async create(createUserDto: CreateUserDto): Promise<UserDocument> {
    const existing = await this.userModel.findOne({ email: createUserDto.email }).lean();
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const data: Record<string, any> = { ...createUserDto };
    if (createUserDto.password) {
      data.password = await bcrypt.hash(createUserDto.password, 12);
    }
    const user = new this.userModel(data);
    return user.save();
  }

  async findAll(query: QueryUserDto) {
    const { page = 1, limit = 20, search, role, sortBy = 'createdAt', sortOrder = 'desc' } = query;
    const skip = (page - 1) * limit;

    const filter: FilterQuery<UserDocument> = { isActive: true };

    if (search) {
      filter.$text = { $search: search };
    }

    if (role) {
      filter.role = role;
    }

    const [data, total] = await Promise.all([
      this.userModel
        .find(filter)
        .sort({ [sortBy]: sortOrder === 'asc' ? 1 : -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.userModel.countDocuments(filter),
    ]);

    return {
      data,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findById(id: string): Promise<UserDocument> {
    const user = await this.userModel.findById(id).exec();
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async findByEmail(email: string): Promise<UserDocument | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<UserDocument> {
    const user = await this.userModel
      .findByIdAndUpdate(id, { $set: updateUserDto }, { new: true, runValidators: true })
      .exec();
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async remove(id: string): Promise<void> {
    const result = await this.userModel.findByIdAndUpdate(id, { isActive: false }).exec();
    if (!result) throw new NotFoundException('User not found');
  }

  async setRefreshToken(userId: string, refreshToken: string | null): Promise<void> {
    const hashed = refreshToken ? await bcrypt.hash(refreshToken, 12) : null;
    await this.userModel.findByIdAndUpdate(userId, { refreshToken: hashed });
  }

  async findByGoogleId(googleId: string): Promise<UserDocument | null> {
    return this.userModel.findOne({ googleId }).exec();
  }

  async findOrCreateByGoogle(
    googleId: string,
    email: string,
    name: string,
    avatar?: string,
  ): Promise<UserDocument> {
    const existing = await this.findByGoogleId(googleId);
    if (existing) {
      if (avatar && existing.avatar !== avatar) {
        existing.avatar = avatar;
        await existing.save();
      }
      return existing;
    }

    const existingByEmail = await this.findByEmail(email);
    if (existingByEmail) {
      existingByEmail.googleId = googleId;
      if (avatar) existingByEmail.avatar = avatar;
      await existingByEmail.save();
      return existingByEmail;
    }

    const user = new this.userModel({ googleId, email, name, avatar });
    return user.save();
  }
}
