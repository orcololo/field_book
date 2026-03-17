import { Test, TestingModule } from '@nestjs/testing';
import { getModelToken } from '@nestjs/mongoose';
import { SpeciesService } from './species.service';
import { Species } from './schemas/species.schema';

describe('SpeciesService', () => {
  let service: SpeciesService;

  const mockSpeciesModel = {
    findOne: jest.fn(),
    find: jest.fn(),
    findById: jest.fn(),
    findByIdAndUpdate: jest.fn(),
    countDocuments: jest.fn(),
    new: jest.fn(),
    constructor: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SpeciesService,
        { provide: getModelToken(Species.name), useValue: mockSpeciesModel },
      ],
    }).compile();

    service = module.get<SpeciesService>(SpeciesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findOrCreate', () => {
    it('should return existing species when found', async () => {
      const existing = { _id: 'species-id', scientificName: 'Rosa alba' };
      mockSpeciesModel.findOne.mockReturnValue({
        exec: jest.fn().mockResolvedValue(existing),
      });

      const result = await service.findOrCreate(
        { scientificName: 'Rosa alba' } as any,
        '507f1f77bcf86cd799439011',
      );

      expect(result).toEqual(existing);
      expect(mockSpeciesModel.findOne).toHaveBeenCalledWith({
        scientificNameLower: 'rosa alba',
      });
    });
  });

  describe('findAll', () => {
    it('should return paginated results', async () => {
      const speciesData = [
        { _id: '1', scientificName: 'Rosa alba' },
        { _id: '2', scientificName: 'Quercus robur' },
      ];

      mockSpeciesModel.find.mockReturnValue({
        sort: jest.fn().mockReturnValue({
          skip: jest.fn().mockReturnValue({
            limit: jest.fn().mockReturnValue({
              lean: jest.fn().mockReturnValue({
                exec: jest.fn().mockResolvedValue(speciesData),
              }),
            }),
          }),
        }),
      });
      mockSpeciesModel.countDocuments.mockResolvedValue(2);

      const result = await service.findAll({ page: 1, limit: 20 } as any);

      expect(result.data).toEqual(speciesData);
      expect(result.meta.total).toBe(2);
    });

    it('should filter by category when provided', async () => {
      mockSpeciesModel.find.mockReturnValue({
        sort: jest.fn().mockReturnValue({
          skip: jest.fn().mockReturnValue({
            limit: jest.fn().mockReturnValue({
              lean: jest.fn().mockReturnValue({
                exec: jest.fn().mockResolvedValue([]),
              }),
            }),
          }),
        }),
      });
      mockSpeciesModel.countDocuments.mockResolvedValue(0);

      await service.findAll({ page: 1, limit: 20, category: 'tree' } as any);

      expect(mockSpeciesModel.find).toHaveBeenCalledWith(
        expect.objectContaining({ category: 'tree', isActive: true }),
      );
    });
  });

  describe('findById', () => {
    it('should return species when found', async () => {
      const species = { _id: 'id', scientificName: 'Rosa alba', isActive: true };
      mockSpeciesModel.findById.mockReturnValue({
        exec: jest.fn().mockResolvedValue(species),
      });

      const result = await service.findById('id');
      expect(result).toEqual(species);
    });

    it('should throw NotFoundException when species not found', async () => {
      mockSpeciesModel.findById.mockReturnValue({
        exec: jest.fn().mockResolvedValue(null),
      });

      await expect(service.findById('bad-id')).rejects.toThrow('Species not found');
    });
  });

  describe('remove', () => {
    it('should soft-delete species', async () => {
      mockSpeciesModel.findByIdAndUpdate.mockReturnValue({
        exec: jest.fn().mockResolvedValue({ _id: 'id' }),
      });

      await service.remove('id');

      expect(mockSpeciesModel.findByIdAndUpdate).toHaveBeenCalledWith(
        'id',
        { isActive: false },
      );
    });

    it('should throw NotFoundException when species not found', async () => {
      mockSpeciesModel.findByIdAndUpdate.mockReturnValue({
        exec: jest.fn().mockResolvedValue(null),
      });

      await expect(service.remove('bad-id')).rejects.toThrow('Species not found');
    });
  });
});
