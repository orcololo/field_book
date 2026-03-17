import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, FilterQuery, Types } from 'mongoose';
import { Registry, RegistryDocument, ImageRef } from './schemas/registry.schema';
import { CreateRegistryDto, UpdateRegistryDto, QueryRegistryDto } from './dto';
import { SpeciesService } from '../species/species.service';
import { UploadService, UploadResult } from '../upload/upload.service';

@Injectable()
export class RegistryService {
  constructor(
    @InjectModel(Registry.name) private readonly registryModel: Model<RegistryDocument>,
    private readonly speciesService: SpeciesService,
    private readonly uploadService: UploadService,
  ) {}

  async create(dto: CreateRegistryDto, userId: string): Promise<RegistryDocument> {
    const existingUuid = await this.registryModel
      .findOne({ uuid: dto.uuid })
      .lean()
      .exec();
    if (existingUuid) {
      throw new ConflictException('Registry with this UUID already exists');
    }

    const existingId = await this.registryModel
      .findOne({ registryIdentifier: dto.registryIdentifier })
      .lean()
      .exec();
    if (existingId) {
      throw new ConflictException('Registry identifier already exists');
    }

    const species = await this.speciesService.findOrCreate(
      {
        scientificName: dto.scientificName,
        commonName: dto.commonName,
        family: dto.family,
        genus: dto.genus,
        species: dto.speciesEpithet,
        category: dto.category,
      },
      userId,
    );

    const {
      scientificName, commonName, family, genus, speciesEpithet, category, deviceId,
      ...rest
    } = dto;

    const registry = new this.registryModel({
      ...rest,
      species: species._id,
      collector: new Types.ObjectId(userId),
      syncMetadata: {
        deviceId,
        syncStatus: 'synced',
        lastSyncedAt: new Date(),
        syncVersion: 1,
      },
    });
    return registry.save();
  }

  async findAll(query: QueryRegistryDto, currentUserId: string) {
    const {
      page = 1,
      limit = 20,
      collector,
      sessionId,
      speciesId,
      isDraft,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc',
    } = query;
    const skip = (page - 1) * limit;

    const filter: FilterQuery<RegistryDocument> = { isActive: true };

    if (collector) {
      filter.collector = new Types.ObjectId(
        collector === 'me' ? currentUserId : collector,
      );
    }
    if (sessionId) {
      filter.sessionId = sessionId;
    }
    if (speciesId) {
      filter.species = new Types.ObjectId(speciesId);
    }
    if (isDraft !== undefined) {
      filter.isDraft = isDraft;
    }
    if (search) {
      filter.$text = { $search: search };
    }

    const [data, total] = await Promise.all([
      this.registryModel
        .find(filter)
        .populate('species')
        .populate('collector', 'name email')
        .sort({ [sortBy]: sortOrder === 'asc' ? 1 : -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.registryModel.countDocuments(filter),
    ]);

    return {
      data,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async findById(id: string): Promise<RegistryDocument> {
    const registry = await this.registryModel
      .findById(id)
      .populate('species')
      .populate('collector', 'name email')
      .exec();
    if (!registry || !registry.isActive) {
      throw new NotFoundException('Registry not found');
    }
    return registry;
  }

  async update(
    id: string,
    dto: UpdateRegistryDto,
    currentUserId: string,
    currentUserRole: string,
  ): Promise<RegistryDocument> {
    const registry = await this.findById(id);
    this.assertOwnerOrAdmin(registry, currentUserId, currentUserRole);

    if (dto.scientificName) {
      const species = await this.speciesService.findOrCreate(
        {
          scientificName: dto.scientificName,
          commonName: dto.commonName,
          family: dto.family,
          genus: dto.genus,
          species: dto.speciesEpithet,
          category: dto.category,
        },
        currentUserId,
      );
      (registry as any).species = species._id;
    }

    const {
      scientificName, commonName, family, genus, speciesEpithet, category, deviceId,
      ...rest
    } = dto;
    Object.assign(registry, rest);
    return registry.save();
  }

  async remove(
    id: string,
    currentUserId: string,
    currentUserRole: string,
  ): Promise<void> {
    const registry = await this.findById(id);
    this.assertOwnerOrAdmin(registry, currentUserId, currentUserRole);
    registry.isActive = false;
    await registry.save();
  }

  async attachImage(
    id: string,
    file: Express.Multer.File,
    currentUserId: string,
    currentUserRole: string,
  ): Promise<RegistryDocument> {
    const registry = await this.findById(id);
    this.assertOwnerOrAdmin(registry, currentUserId, currentUserRole);

    const result: UploadResult = await this.uploadService.uploadImage(
      file,
      currentUserId,
      id,
    );

    const imageRef: ImageRef = {
      key: result.key,
      url: result.url,
      thumbnailKey: result.thumbnailKey,
      thumbnailUrl: result.thumbnailUrl,
    };

    registry.images.push(imageRef as any);
    return registry.save();
  }

  async removeImage(
    id: string,
    imageKey: string,
    currentUserId: string,
    currentUserRole: string,
  ): Promise<RegistryDocument> {
    const registry = await this.findById(id);
    this.assertOwnerOrAdmin(registry, currentUserId, currentUserRole);

    const idx = registry.images.findIndex((img) => img.key === imageKey);
    if (idx === -1) throw new NotFoundException('Image not found in registry');

    await this.uploadService.deleteImage(imageKey);
    registry.images.splice(idx, 1);
    return registry.save();
  }

  private assertOwnerOrAdmin(
    registry: RegistryDocument,
    currentUserId: string,
    currentUserRole: string,
  ): void {
    const ownerId = registry.collector.toString();
    if (ownerId !== currentUserId && currentUserRole !== 'admin') {
      throw new ForbiddenException('You can only modify your own registries');
    }
  }
}
