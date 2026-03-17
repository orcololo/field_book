import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Registry, RegistryDocument } from '../registry/schemas/registry.schema';
import {
  CollectionSession,
  CollectionSessionDocument,
} from '../collection-sessions/schemas/collection-session.schema';
import { SpeciesService } from '../species/species.service';
import {
  SyncPushDto,
  SyncPullDto,
  SyncRegistryItemDto,
  SyncSessionItemDto,
} from './dto';

export interface SyncItemResult {
  uuid: string;
  status: 'created' | 'updated' | 'conflict' | 'error';
  serverId?: string;
  syncVersion?: number;
  message?: string;
}

export interface SyncPushResult {
  registries: SyncItemResult[];
  sessions: SyncItemResult[];
  syncedAt: string;
}

export interface SyncPullResult {
  registries: RegistryDocument[];
  sessions: CollectionSessionDocument[];
  syncedAt: string;
  hasMore: boolean;
}

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    @InjectModel(Registry.name)
    private readonly registryModel: Model<RegistryDocument>,
    @InjectModel(CollectionSession.name)
    private readonly sessionModel: Model<CollectionSessionDocument>,
    private readonly speciesService: SpeciesService,
  ) {}

  async push(dto: SyncPushDto, userId: string): Promise<SyncPushResult> {
    const syncedAt = new Date().toISOString();
    const registryResults: SyncItemResult[] = [];
    const sessionResults: SyncItemResult[] = [];

    // Process sessions first (registries may reference them)
    if (dto.sessions?.length) {
      for (const item of dto.sessions) {
        const result = await this.upsertSession(item, userId, dto.deviceId);
        sessionResults.push(result);
      }
    }

    // Process registries
    if (dto.registries?.length) {
      for (const item of dto.registries) {
        const result = await this.upsertRegistry(item, userId, dto.deviceId);
        registryResults.push(result);
      }
    }

    return { registries: registryResults, sessions: sessionResults, syncedAt };
  }

  async pull(
    dto: SyncPullDto,
    userId: string,
  ): Promise<SyncPullResult> {
    const since = dto.since ? new Date(dto.since) : new Date(0);
    const limit = dto.limit ?? 100;
    const syncedAt = new Date().toISOString();

    const [registries, sessions] = await Promise.all([
      this.registryModel
        .find({
          collector: new Types.ObjectId(userId),
          updatedAt: { $gt: since },
          isActive: true,
        })
        .populate('species')
        .sort({ updatedAt: 1 })
        .limit(limit + 1)
        .exec(),
      this.sessionModel
        .find({
          owner: new Types.ObjectId(userId),
          updatedAt: { $gt: since },
          isActive: true,
        })
        .sort({ updatedAt: 1 })
        .limit(limit + 1)
        .exec(),
    ]);

    const hasMoreRegistries = registries.length > limit;
    const hasMoreSessions = sessions.length > limit;

    return {
      registries: registries.slice(0, limit),
      sessions: sessions.slice(0, limit),
      syncedAt,
      hasMore: hasMoreRegistries || hasMoreSessions,
    };
  }

  // ── Private upsert methods ──

  private async upsertRegistry(
    item: SyncRegistryItemDto,
    userId: string,
    deviceId: string,
  ): Promise<SyncItemResult> {
    try {
      const existing = await this.registryModel
        .findOne({ uuid: item.uuid })
        .exec();

      if (!existing) {
        return this.createRegistryFromSync(item, userId, deviceId);
      }

      return this.updateRegistryFromSync(existing, item, deviceId);
    } catch (error) {
      this.logger.error(`Sync upsert failed for registry ${item.uuid}`, error);
      return {
        uuid: item.uuid,
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  private async createRegistryFromSync(
    item: SyncRegistryItemDto,
    userId: string,
    deviceId: string,
  ): Promise<SyncItemResult> {
    const species = await this.speciesService.findOrCreate(
      {
        scientificName: item.scientificName,
        commonName: item.commonName,
        family: item.family,
        genus: item.genus,
        species: item.speciesEpithet,
        category: item.category,
      },
      userId,
    );

    const {
      scientificName, commonName, family, genus, speciesEpithet, category,
      syncVersion, localModifiedAt, deviceId: _,
      ...rest
    } = item;

    const registry = new this.registryModel({
      ...rest,
      species: species._id,
      collector: new Types.ObjectId(userId),
      syncMetadata: {
        deviceId,
        syncStatus: 'synced',
        lastSyncedAt: new Date(),
        localModifiedAt: localModifiedAt ? new Date(localModifiedAt) : undefined,
        syncVersion: 1,
      },
    });

    const saved = await registry.save();
    return {
      uuid: item.uuid,
      status: 'created',
      serverId: saved._id.toString(),
      syncVersion: 1,
    };
  }

  private async updateRegistryFromSync(
    existing: RegistryDocument,
    item: SyncRegistryItemDto,
    deviceId: string,
  ): Promise<SyncItemResult> {
    const serverVersion = existing.syncMetadata?.syncVersion ?? 0;

    // Conflict: client version doesn't match server version
    if (item.syncVersion < serverVersion) {
      existing.syncMetadata = {
        ...existing.syncMetadata,
        syncVersion: serverVersion,
        syncStatus: 'conflict',
        conflictData: JSON.stringify(item),
      };
      await existing.save();
      return {
        uuid: item.uuid,
        status: 'conflict',
        serverId: existing._id.toString(),
        syncVersion: serverVersion,
        message: `Server version ${serverVersion} > client version ${item.syncVersion}`,
      };
    }

    // Last-write-wins: update fields
    const {
      scientificName, commonName, family, genus, speciesEpithet, category,
      syncVersion: _, localModifiedAt, deviceId: __, uuid: ___,
      ...updateFields
    } = item;

    // Re-link species if taxonomy changed
    if (scientificName && scientificName !== (existing as any).species?.scientificName) {
      const species = await this.speciesService.findOrCreate(
        { scientificName, commonName, family, genus, species: speciesEpithet, category },
        existing.collector.toString(),
      );
      (existing as any).species = species._id;
    }

    Object.assign(existing, updateFields);
    const newVersion = serverVersion + 1;
    existing.syncMetadata = {
      deviceId,
      syncStatus: 'synced',
      lastSyncedAt: new Date(),
      localModifiedAt: localModifiedAt ? new Date(localModifiedAt) : undefined,
      syncVersion: newVersion,
    };

    await existing.save();
    return {
      uuid: item.uuid,
      status: 'updated',
      serverId: existing._id.toString(),
      syncVersion: newVersion,
    };
  }

  private async upsertSession(
    item: SyncSessionItemDto,
    userId: string,
    deviceId: string,
  ): Promise<SyncItemResult> {
    try {
      const existing = await this.sessionModel
        .findOne({ uuid: item.uuid })
        .exec();

      if (!existing) {
        return this.createSessionFromSync(item, userId, deviceId);
      }

      return this.updateSessionFromSync(existing, item, deviceId);
    } catch (error) {
      this.logger.error(`Sync upsert failed for session ${item.uuid}`, error);
      return {
        uuid: item.uuid,
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  private async createSessionFromSync(
    item: SyncSessionItemDto,
    userId: string,
    deviceId: string,
  ): Promise<SyncItemResult> {
    const { syncVersion, localModifiedAt, deviceId: _, ...rest } = item;

    const session = new this.sessionModel({
      ...rest,
      owner: new Types.ObjectId(userId),
      syncMetadata: {
        deviceId,
        syncStatus: 'synced',
        lastSyncedAt: new Date(),
        localModifiedAt: localModifiedAt ? new Date(localModifiedAt) : undefined,
        syncVersion: 1,
      },
    });

    const saved = await session.save();
    return {
      uuid: item.uuid,
      status: 'created',
      serverId: saved._id.toString(),
      syncVersion: 1,
    };
  }

  private async updateSessionFromSync(
    existing: CollectionSessionDocument,
    item: SyncSessionItemDto,
    deviceId: string,
  ): Promise<SyncItemResult> {
    const serverVersion = existing.syncMetadata?.syncVersion ?? 0;

    if (item.syncVersion < serverVersion) {
      existing.syncMetadata = {
        ...existing.syncMetadata,
        syncVersion: serverVersion,
        syncStatus: 'conflict',
        conflictData: JSON.stringify(item),
      };
      await existing.save();
      return {
        uuid: item.uuid,
        status: 'conflict',
        serverId: existing._id.toString(),
        syncVersion: serverVersion,
        message: `Server version ${serverVersion} > client version ${item.syncVersion}`,
      };
    }

    const { syncVersion: _, localModifiedAt, deviceId: __, uuid: ___, ...updateFields } = item;
    Object.assign(existing, updateFields);

    const newVersion = serverVersion + 1;
    existing.syncMetadata = {
      deviceId,
      syncStatus: 'synced',
      lastSyncedAt: new Date(),
      localModifiedAt: localModifiedAt ? new Date(localModifiedAt) : undefined,
      syncVersion: newVersion,
    };

    await existing.save();
    return {
      uuid: item.uuid,
      status: 'updated',
      serverId: existing._id.toString(),
      syncVersion: newVersion,
    };
  }
}
