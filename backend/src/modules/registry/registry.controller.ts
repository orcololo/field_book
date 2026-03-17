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
  UseInterceptors,
  UploadedFile,
  ParseFilePipe,
  MaxFileSizeValidator,
  FileTypeValidator,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ParseObjectIdPipe } from '../../common/pipes';
import { RegistryService } from './registry.service';
import { CreateRegistryDto, UpdateRegistryDto, QueryRegistryDto } from './dto';
import {
  RegistryResponseDto,
  PaginatedRegistriesResponseDto,
  DeleteResponseDto,
  UploadResultDto,
} from '../../common/dto';

@ApiTags('Registries')
@Controller('registries')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class RegistryController {
  constructor(private readonly registryService: RegistryService) {}

  @Post()
  @ApiOperation({ summary: 'Create a specimen registry (auto-links or creates species)' })
  @ApiResponse({ status: 201, description: 'Registry created', type: RegistryResponseDto })
  @ApiResponse({ status: 409, description: 'Registry identifier already exists' })
  create(
    @Body() dto: CreateRegistryDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.registryService.create(dto, userId);
  }

  @Get()
  @ApiOperation({ summary: 'List registries with filters (collector=me, sessionId, speciesId)' })
  @ApiResponse({ status: 200, description: 'Paginated registries', type: PaginatedRegistriesResponseDto })
  findAll(
    @Query() query: QueryRegistryDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.registryService.findAll(query, userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a single registry by ID' })
  @ApiResponse({ status: 200, description: 'Registry found', type: RegistryResponseDto })
  @ApiResponse({ status: 404, description: 'Registry not found' })
  findOne(@Param('id', ParseObjectIdPipe) id: string) {
    return this.registryService.findById(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a registry (owner or admin only)' })
  @ApiResponse({ status: 200, description: 'Registry updated', type: RegistryResponseDto })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  update(
    @Param('id', ParseObjectIdPipe) id: string,
    @Body() dto: UpdateRegistryDto,
    @CurrentUser('userId') userId: string,
    @CurrentUser('role') role: string,
  ) {
    return this.registryService.update(id, dto, userId, role);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Soft-delete a registry (owner or admin only)' })
  @ApiResponse({ status: 200, description: 'Registry deleted', type: DeleteResponseDto })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  async remove(
    @Param('id', ParseObjectIdPipe) id: string,
    @CurrentUser('userId') userId: string,
    @CurrentUser('role') role: string,
  ) {
    await this.registryService.remove(id, userId, role);
    return { deleted: true };
  }

  @Post(':id/images')
  @ApiOperation({ summary: 'Upload and attach an image to a registry' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: { file: { type: 'string', format: 'binary' } },
    },
  })
  @ApiResponse({ status: 201, description: 'Image attached', type: UploadResultDto })
  @UseInterceptors(FileInterceptor('file'))
  attachImage(
    @Param('id', ParseObjectIdPipe) id: string,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({ maxSize: 10 * 1024 * 1024 }),
          new FileTypeValidator({ fileType: /^image\/(jpeg|png|webp)$/ }),
        ],
      }),
    )
    file: Express.Multer.File,
    @CurrentUser('userId') userId: string,
    @CurrentUser('role') role: string,
  ) {
    return this.registryService.attachImage(id, file, userId, role);
  }

  @Delete(':id/images/*')
  @ApiOperation({ summary: 'Remove an image from a registry and R2 (pass full R2 key as path)' })
  @ApiResponse({ status: 200, description: 'Image removed', type: DeleteResponseDto })
  removeImage(
    @Param('id', ParseObjectIdPipe) id: string,
    @Param('0') key: string,
    @CurrentUser('userId') userId: string,
    @CurrentUser('role') role: string,
  ) {
    return this.registryService.removeImage(id, key, userId, role);
  }
}
