import { Controller, Post, Get, Body, Query, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { SyncService } from './sync.service';
import { SyncPushDto, SyncPullDto } from './dto';

@ApiTags('Sync')
@Controller('sync')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class SyncController {
  constructor(private readonly syncService: SyncService) {}

  @Post('push')
  @ApiOperation({
    summary: 'Push local changes to server (batch upsert registries + sessions)',
    description:
      'Accepts arrays of registries and sessions from the client. ' +
      'Each item is upserted by UUID. Returns per-item status: created, updated, conflict, or error.',
  })
  @ApiResponse({ status: 201, description: 'Push results with per-item status' })
  push(
    @Body() dto: SyncPushDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.syncService.push(dto, userId);
  }

  @Get('pull')
  @ApiOperation({
    summary: 'Pull server changes since last sync timestamp',
    description:
      'Returns registries and sessions modified after the given timestamp. ' +
      'Use `since` param with the `syncedAt` value from the last pull. ' +
      'If `hasMore` is true, call again with the same `since` but paginated.',
  })
  @ApiResponse({ status: 200, description: 'Changed registries and sessions' })
  pull(
    @Query() dto: SyncPullDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.syncService.pull(dto, userId);
  }
}
