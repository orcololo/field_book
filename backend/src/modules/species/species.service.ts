import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, FilterQuery, Types } from 'mongoose';
import { Species, SpeciesDocument } from './schemas/species.schema';
import { CreateSpeciesDto, QuerySpeciesDto } from './dto';

@Injectable()
export class SpeciesService {
  constructor(
    @InjectModel(Species.name) private readonly speciesModel: Model<SpeciesDocument>,
  ) {}

  async findOrCreate(dto: CreateSpeciesDto, userId: string): Promise<SpeciesDocument> {
    const normalised = dto.scientificName.toLowerCase().trim();
    const existing = await this.speciesModel
      .findOne({ scientificNameLower: normalised })
      .exec();
    if (existing) return existing;

    const species = new this.speciesModel({
      ...dto,
      scientificNameLower: normalised,
      createdBy: new Types.ObjectId(userId),
    });
    return species.save();
  }

  async findAll(query: QuerySpeciesDto) {
    const { page = 1, limit = 20, search, category, family, sortBy = 'scientificName', sortOrder = 'asc' } = query;
    const skip = (page - 1) * limit;

    const filter: FilterQuery<SpeciesDocument> = { isActive: true };

    if (search) {
      filter.$text = { $search: search };
    }
    if (category) {
      filter.category = category;
    }
    if (family) {
      filter.family = { $regex: new RegExp(`^${family.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`, 'i') };
    }

    const [data, total] = await Promise.all([
      this.speciesModel
        .find(filter)
        .sort({ [sortBy]: sortOrder === 'asc' ? 1 : -1 })
        .skip(skip)
        .limit(limit)
        .lean()
        .exec(),
      this.speciesModel.countDocuments(filter),
    ]);

    return {
      data,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async findById(id: string): Promise<SpeciesDocument> {
    const species = await this.speciesModel.findById(id).exec();
    if (!species || !species.isActive) {
      throw new NotFoundException('Species not found');
    }
    return species;
  }

  async update(id: string, dto: Partial<CreateSpeciesDto>): Promise<SpeciesDocument> {
    const species = await this.speciesModel
      .findByIdAndUpdate(id, { $set: dto }, { new: true, runValidators: true })
      .exec();
    if (!species) throw new NotFoundException('Species not found');
    return species;
  }

  async remove(id: string): Promise<void> {
    const result = await this.speciesModel.findByIdAndUpdate(id, { isActive: false }).exec();
    if (!result) throw new NotFoundException('Species not found');
  }
}
