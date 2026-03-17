import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, FilterQuery, Types } from 'mongoose';
import {
  CollectionSession,
  CollectionSessionDocument,
} from './schemas/collection-session.schema';
import {
  CreateCollectionSessionDto,
  UpdateCollectionSessionDto,
  QueryCollectionSessionDto,
} from './dto';

@Injectable()
export class CollectionSessionsService {
  constructor(
    @InjectModel(CollectionSession.name)
    private readonly sessionModel: Model<CollectionSessionDocument>,
  ) {}

  async create(
    dto: CreateCollectionSessionDto,
    userId: string,
  ): Promise<CollectionSessionDocument> {
    const existing = await this.sessionModel
      .findOne({ uuid: dto.uuid })
      .lean()
      .exec();
    if (existing) {
      throw new ConflictException('Session with this UUID already exists');
    }

    const { deviceId, ...rest } = dto;

    const session = new this.sessionModel({
      ...rest,
      owner: new Types.ObjectId(userId),
      syncMetadata: {
        deviceId,
        syncStatus: 'synced',
        lastSyncedAt: new Date(),
        syncVersion: 1,
      },
    });
    return session.save();
  }

  async findAll(query: QueryCollectionSessionDto, currentUserId: string) {
    const {
      page = 1,
      limit = 20,
      search,
      isArchived,
      sortBy = 'createdAt',
      sortOrder = 'desc',
    } = query;
    const skip = (page - 1) * limit;

    const filter: FilterQuery<CollectionSessionDocument> = {
      isActive: true,
      owner: new Types.ObjectId(currentUserId),
    };

    if (search) {
      filter.$text = { $search: search };
    }
    if (isArchived !== undefined) {
      filter.isArchived = isArchived;
    }

    const [data, total] = await Promise.all([
      this.sessionModel
        .find(filter)
        .populate('owner', 'name email')
        .sort({ [sortBy]: sortOrder === 'asc' ? 1 : -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.sessionModel.countDocuments(filter),
    ]);

    return {
      data,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async findById(id: string): Promise<CollectionSessionDocument> {
    const session = await this.sessionModel
      .findById(id)
      .populate('owner', 'name email')
      .exec();
    if (!session || !session.isActive) {
      throw new NotFoundException('Collection session not found');
    }
    return session;
  }

  async findByUuid(uuid: string): Promise<CollectionSessionDocument | null> {
    return this.sessionModel.findOne({ uuid, isActive: true }).exec();
  }

  async update(
    id: string,
    dto: UpdateCollectionSessionDto,
    currentUserId: string,
  ): Promise<CollectionSessionDocument> {
    const session = await this.findById(id);
    this.assertOwner(session, currentUserId);

    const { deviceId, ...rest } = dto;
    Object.assign(session, rest);
    return session.save();
  }

  async remove(id: string, currentUserId: string): Promise<void> {
    const session = await this.findById(id);
    this.assertOwner(session, currentUserId);
    session.isActive = false;
    await session.save();
  }

  private assertOwner(
    session: CollectionSessionDocument,
    currentUserId: string,
  ): void {
    if (session.owner.toString() !== currentUserId) {
      throw new ForbiddenException('You can only modify your own sessions');
    }
  }
}
