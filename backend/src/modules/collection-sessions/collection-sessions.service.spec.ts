import { Test, TestingModule } from '@nestjs/testing';
import { getModelToken } from '@nestjs/mongoose';
import { ConflictException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { CollectionSessionsService } from './collection-sessions.service';
import { CollectionSession } from './schemas/collection-session.schema';

describe('CollectionSessionsService', () => {
  let service: CollectionSessionsService;
  let mockSessionModel: any;

  beforeEach(async () => {
    jest.clearAllMocks();

    mockSessionModel = jest.fn().mockImplementation((data) => ({
      ...data,
      save: jest.fn().mockResolvedValue({ _id: 'new-id', ...data }),
    }));
    mockSessionModel.findOne = jest.fn();
    mockSessionModel.find = jest.fn();
    mockSessionModel.findById = jest.fn();
    mockSessionModel.countDocuments = jest.fn();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CollectionSessionsService,
        { provide: getModelToken(CollectionSession.name), useValue: mockSessionModel },
      ],
    }).compile();

    service = module.get<CollectionSessionsService>(CollectionSessionsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should throw ConflictException when UUID exists', async () => {
      mockSessionModel.findOne.mockReturnValue({
        lean: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue({ _id: 'existing' }),
        }),
      });

      await expect(
        service.create({ uuid: 'dup-uuid', tripName: 'Test' } as any, '507f1f77bcf86cd799439011'),
      ).rejects.toThrow(ConflictException);
    });

    it('should create session when UUID is unique', async () => {
      mockSessionModel.findOne.mockReturnValue({
        lean: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue(null),
        }),
      });

      const result = await service.create(
        { uuid: 'new-uuid', tripName: 'Field Trip 1' } as any,
        '507f1f77bcf86cd799439011',
      );

      expect(result).toBeDefined();
    });
  });

  describe('findAll', () => {
    it('should return paginated results for current user', async () => {
      const sessions = [{ _id: '1', tripName: 'Trip 1' }];
      mockSessionModel.find.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          sort: jest.fn().mockReturnValue({
            skip: jest.fn().mockReturnValue({
              limit: jest.fn().mockReturnValue({
                exec: jest.fn().mockResolvedValue(sessions),
              }),
            }),
          }),
        }),
      });
      mockSessionModel.countDocuments.mockResolvedValue(1);

      const result = await service.findAll(
        { page: 1, limit: 20 } as any,
        '507f1f77bcf86cd799439011',
      );

      expect(result.data).toEqual(sessions);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('findById', () => {
    it('should throw NotFoundException when not found', async () => {
      mockSessionModel.findById.mockReturnValue({
        populate: jest.fn().mockReturnValue({
          exec: jest.fn().mockResolvedValue(null),
        }),
      });

      await expect(service.findById('bad-id')).rejects.toThrow(NotFoundException);
    });
  });
});
