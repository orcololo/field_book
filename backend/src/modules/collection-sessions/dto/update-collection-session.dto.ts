import { PartialType } from '@nestjs/swagger';
import { CreateCollectionSessionDto } from './create-collection-session.dto';

export class UpdateCollectionSessionDto extends PartialType(CreateCollectionSessionDto) {}
