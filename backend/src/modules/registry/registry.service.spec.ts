import { Test, TestingModule } from '@nestjs/testing';
import { getModelToken } from '@nestjs/mongoose';
import { NotFoundException, ForbiddenException, ConflictException } from '@nestjs/common';
import { RegistryService } from './registry.service';
import { Registry } from './schemas/registry.schema';
import { SpeciesService } from '../species/species.service';
import { UploadService } from '../upload/upload.service';

describe('RegistryService', () => {
  let service: RegistryService;
  let mockRegistryModel: any;

  const mockSpeciesService = {
    findOrCreate: jest.fn(),
  };

  const mockUploadService = {
    uploadImage: jest.fn(),
    deleteImage: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    mockRegistryModel = jest.fn().mockImplementation((data) => ({
      ...data,
      save: jest.fn().mockResolvedValue({ _id: 'new-id', ...data }),
    }));
    mockRegistryModel.findOne = jest.fn();
    mockRegistryModel.find = jest.fn();
    mockRegistryModel.findById = jest.fn();
    mockRegistryModel.countDocuments = jest.fn();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RegistryService,
        { provide: getModelToken(Registry.name), useValue: mockRegistryModel },
        { provide: SpeciesService, useValue: mockSpeciesService },
        { provide: UploadService, useValue: mockUploadService },
      ],
    }).compile();

    service = module.get<RegistryService>(RegistryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createDto = {
      uuid: 'test-uuid',
      registryIdentifier: 'RC000001',
      scientificName: 'Rosa alba',
      commonName: 'White Rose',
      category: 'shrub',
    };

    it('should throw ConflictException when UUID already exists', async () => {
      mockRegistryModel.findOne.mockReturnValueOnce({
        lean: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue({ _id: 'existing' }),
        }),
      });

      await expect(service.create(createDto as any, '507f1f77bcf86cd799439011')).rejects.toThrow(
        ConflictException,
      );
    });

    it('should throw ConflictException when identifier already exists', async () => {
      // First call (UUID check) returns null
      mockRegistryModel.findOne.mockReturnValueOnce({
        lean: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue(null),
        }),
      });
      // Second call (identifier check) returns existing
      mockRegistryModel.findOne.mockReturnValueOnce({
        lean: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue({ _id: 'existing' }),
        }),
      });

      await expect(service.create(createDto as any, '507f1f77bcf86cd799439011')).rejects.toThrow(
        ConflictException,
      );
    });
  });

  describe('findAll', () => {
    it('should return paginated results', async () => {
      const registries = [{ _id: '1' }, { _id: '2' }];
      mockRegistryModel.find.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          populate: jest.fn().mockReturnValue({
            sort: jest.fn().mockReturnValue({
              skip: jest.fn().mockReturnValue({
                limit: jest.fn().mockReturnValue({
                  exec: jest.fn().mockResolvedValue(registries),
                }),
              }),
            }),
          }),
        }),
      });
      mockRegistryModel.countDocuments.mockResolvedValue(2);

      const result = await service.findAll(
        { page: 1, limit: 20 } as any,
        '507f1f77bcf86cd799439011',
      );

      expect(result.data).toEqual(registries);
      expect(result.meta.total).toBe(2);
    });
  });

  describe('findById', () => {
    it('should throw NotFoundException when not found', async () => {
      mockRegistryModel.findById.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          populate: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue(null),
          }),
        }),
      });

      await expect(service.findById('bad-id')).rejects.toThrow(NotFoundException);
    });
  });

  describe('remove', () => {
    it('should soft-delete registry when owner', async () => {
      const registry = {
        _id: 'id',
        isActive: true,
        collector: { toString: () => '507f1f77bcf86cd799439011' },
        save: jest.fn().mockResolvedValue(undefined),
      };
      mockRegistryModel.findById.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          populate: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue(registry),
          }),
        }),
      });

      await service.remove('id', '507f1f77bcf86cd799439011', 'collector');
      expect(registry.isActive).toBe(false);
      expect(registry.save).toHaveBeenCalled();
    });

    it('should throw ForbiddenException when not owner', async () => {
      const registry = {
        _id: 'id',
        isActive: true,
        collector: { toString: () => 'a07f1f77bcf86cd799439022' },
      };
      mockRegistryModel.findById.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          populate: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue(registry),
          }),
        }),
      });

      await expect(
        service.remove('id', '507f1f77bcf86cd799439011', 'collector'),
      ).rejects.toThrow(ForbiddenException);
    });
  });
});
