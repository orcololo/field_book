import { Test, TestingModule } from '@nestjs/testing';
import { getModelToken } from '@nestjs/mongoose';
import { SyncService } from './sync.service';
import { Registry } from '../registry/schemas/registry.schema';
import { CollectionSession } from '../collection-sessions/schemas/collection-session.schema';
import { SpeciesService } from '../species/species.service';

describe('SyncService', () => {
  let service: SyncService;
  let mockRegistryModel: any;
  let mockSessionModel: any;

  const mockSpeciesService = {
    findOrCreate: jest.fn().mockResolvedValue({ _id: 'species-id' }),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    mockRegistryModel = jest.fn().mockImplementation((data) => ({
      ...data,
      save: jest.fn().mockResolvedValue({ _id: 'reg-id', ...data }),
    }));
    mockRegistryModel.findOne = jest.fn();
    mockRegistryModel.find = jest.fn();

    mockSessionModel = jest.fn().mockImplementation((data) => ({
      ...data,
      save: jest.fn().mockResolvedValue({ _id: 'ses-id', ...data }),
    }));
    mockSessionModel.findOne = jest.fn();
    mockSessionModel.find = jest.fn();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SyncService,
        { provide: getModelToken(Registry.name), useValue: mockRegistryModel },
        { provide: getModelToken(CollectionSession.name), useValue: mockSessionModel },
        { provide: SpeciesService, useValue: mockSpeciesService },
      ],
    }).compile();

    service = module.get<SyncService>(SyncService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('push', () => {
    it('should create new registry when UUID does not exist', async () => {
      mockRegistryModel.findOne.mockReturnValue({
        exec: jest.fn().mockResolvedValue(null),
      });

      const result = await service.push(
        {
          registries: [
            {
              uuid: 'new-uuid',
              scientificName: 'Rosa alba',
              commonName: 'White Rose',
              syncVersion: 0,
            } as any,
          ],
          sessions: [],
          deviceId: 'device-1',
        },
        '507f1f77bcf86cd799439011',
      );

      expect(result.registries).toHaveLength(1);
      expect(result.registries[0].status).toBe('created');
    });

    it('should detect conflict when client version is behind', async () => {
      const existing = {
        _id: 'existing-id',
        uuid: 'uuid-1',
        syncMetadata: { syncVersion: 3 },
        save: jest.fn().mockResolvedValue(undefined),
        collector: { toString: () => '507f1f77bcf86cd799439011' },
      };
      mockRegistryModel.findOne.mockReturnValue({
        exec: jest.fn().mockResolvedValue(existing),
      });

      const result = await service.push(
        {
          registries: [
            {
              uuid: 'uuid-1',
              scientificName: 'Rosa alba',
              syncVersion: 1,
            } as any,
          ],
          sessions: [],
          deviceId: 'device-1',
        },
        '507f1f77bcf86cd799439011',
      );

      expect(result.registries[0].status).toBe('conflict');
    });

    it('should create new session when UUID does not exist', async () => {
      mockSessionModel.findOne.mockReturnValue({
        exec: jest.fn().mockResolvedValue(null),
      });

      const result = await service.push(
        {
          registries: [],
          sessions: [
            {
              uuid: 'session-uuid',
              tripName: 'Field Trip',
              syncVersion: 0,
            } as any,
          ],
          deviceId: 'device-1',
        },
        '507f1f77bcf86cd799439011',
      );

      expect(result.sessions).toHaveLength(1);
      expect(result.sessions[0].status).toBe('created');
    });
  });

  describe('pull', () => {
    it('should return registries and sessions modified after since', async () => {
      const registries = [{ _id: '1', uuid: 'r1' }];
      const sessions = [{ _id: '2', uuid: 's1' }];

      mockRegistryModel.find.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          sort: jest.fn().mockReturnValue({
            limit: jest.fn().mockReturnValue({
              exec: jest.fn().mockResolvedValue(registries),
            }),
          }),
        }),
      });
      mockSessionModel.find.mockReturnValue({
        sort: jest.fn().mockReturnValue({
          limit: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue(sessions),
          }),
        }),
      });

      const result = await service.pull(
        { since: '2025-01-01T00:00:00Z', limit: 100 },
        '507f1f77bcf86cd799439011',
      );

      expect(result.registries).toHaveLength(1);
      expect(result.sessions).toHaveLength(1);
      expect(result.hasMore).toBe(false);
    });

    it('should set hasMore when results exceed limit', async () => {
      const manyRegistries = Array.from({ length: 3 }, (_, i) => ({
        _id: `${i}`,
        uuid: `r${i}`,
      }));

      mockRegistryModel.find.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          sort: jest.fn().mockReturnValue({
            limit: jest.fn().mockReturnValue({
              exec: jest.fn().mockResolvedValue(manyRegistries),
            }),
          }),
        }),
      });
      mockSessionModel.find.mockReturnValue({
        sort: jest.fn().mockReturnValue({
          limit: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue([]),
          }),
        }),
      });

      const result = await service.pull({ limit: 2 }, '507f1f77bcf86cd799439011');

      expect(result.hasMore).toBe(true);
      expect(result.registries).toHaveLength(2);
    });
  });
});
