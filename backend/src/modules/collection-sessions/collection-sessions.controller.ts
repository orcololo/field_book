import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ParseObjectIdPipe } from '../../common/pipes';
import { CollectionSessionsService } from './collection-sessions.service';
import {
  CreateCollectionSessionDto,
  UpdateCollectionSessionDto,
  QueryCollectionSessionDto,
} from './dto';
import {
  CollectionSessionResponseDto,
  PaginatedSessionsResponseDto,
} from '../../common/dto';

@ApiTags('Collection Sessions')
@Controller('sessions')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class CollectionSessionsController {
  constructor(
    private readonly sessionsService: CollectionSessionsService,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a collection session' })
  @ApiResponse({ status: 201, description: 'Session created', type: CollectionSessionResponseDto })
  @ApiResponse({ status: 409, description: 'Session UUID already exists' })
  create(
    @Body() dto: CreateCollectionSessionDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.sessionsService.create(dto, userId);
  }

  @Get()
  @ApiOperation({ summary: 'List collection sessions for current user' })
  @ApiResponse({ status: 200, description: 'Paginated sessions', type: PaginatedSessionsResponseDto })
  findAll(
    @Query() query: QueryCollectionSessionDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.sessionsService.findAll(query, userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a collection session by ID' })
  @ApiResponse({ status: 200, description: 'Session found', type: CollectionSessionResponseDto })
  @ApiResponse({ status: 404, description: 'Session not found' })
  findOne(@Param('id', ParseObjectIdPipe) id: string) {
    return this.sessionsService.findById(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a collection session (owner only)' })
  @ApiResponse({ status: 200, description: 'Session updated', type: CollectionSessionResponseDto })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  update(
    @Param('id', ParseObjectIdPipe) id: string,
    @Body() dto: UpdateCollectionSessionDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.sessionsService.update(id, dto, userId);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Soft-delete a collection session (owner only)' })
  @ApiResponse({ status: 204, description: 'Session deleted' })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  remove(
    @Param('id', ParseObjectIdPipe) id: string,
    @CurrentUser('userId') userId: string,
  ) {
    return this.sessionsService.remove(id, userId);
  }
}
