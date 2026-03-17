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
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { UserRole } from '../users/schemas/user.schema';
import { ParseObjectIdPipe } from '../../common/pipes';
import { SpeciesService } from './species.service';
import { CreateSpeciesDto, UpdateSpeciesDto, QuerySpeciesDto } from './dto';
import { SpeciesResponseDto, PaginatedSpeciesResponseDto, DeleteResponseDto } from '../../common/dto';

@ApiTags('Species')
@Controller('species')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class SpeciesController {
  constructor(private readonly speciesService: SpeciesService) {}

  @Post()
  @ApiOperation({ summary: 'Create species (or return existing if name matches)' })
  @ApiResponse({ status: 201, description: 'Species created or found', type: SpeciesResponseDto })
  create(
    @Body() dto: CreateSpeciesDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.speciesService.findOrCreate(dto, userId);
  }

  @Get()
  @ApiOperation({ summary: 'List all species (deduplicated, paginated)' })
  @ApiResponse({ status: 200, description: 'Paginated species list', type: PaginatedSpeciesResponseDto })
  findAll(@Query() query: QuerySpeciesDto) {
    return this.speciesService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a single species by ID' })
  @ApiResponse({ status: 200, description: 'Species found', type: SpeciesResponseDto })
  @ApiResponse({ status: 404, description: 'Species not found' })
  findOne(@Param('id', ParseObjectIdPipe) id: string) {
    return this.speciesService.findById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN, UserRole.RESEARCHER)
  @ApiOperation({ summary: 'Update species (admin/researcher only)' })
  @ApiResponse({ status: 200, description: 'Species updated', type: SpeciesResponseDto })
  update(
    @Param('id', ParseObjectIdPipe) id: string,
    @Body() dto: UpdateSpeciesDto,
  ) {
    return this.speciesService.update(id, dto);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Soft-delete a species (admin only)' })
  @ApiResponse({ status: 204, description: 'Species deleted' })
  remove(@Param('id', ParseObjectIdPipe) id: string) {
    return this.speciesService.remove(id);
  }
}
