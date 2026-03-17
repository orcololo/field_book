---
description: "Use when writing or editing NestJS backend TypeScript files. Covers import ordering, naming conventions, Mongoose schema patterns, DTO validation, and module wiring."
applyTo: "backend/src/**/*.ts"
---

# NestJS Backend Conventions

## Import Order

```ts
// 1. NestJS core
import { Controller, Get, Post } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

// 2. Third-party
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { IsString, IsEnum } from 'class-validator';
import { Model } from 'mongoose';

// 3. Local (relative)
import { CreatePlantRecordDto } from './dto/create-plant-record.dto';
import { PlantCategory } from './enums/plant-record.enums';
```

## Naming

| Entity | File | Class |
|--------|------|-------|
| Schema | `plant-record.schema.ts` | `PlantRecord` / `PlantRecordDocument` |
| DTO | `create-plant-record.dto.ts` | `CreatePlantRecordDto` |
| Enum | `plant-record.enums.ts` | `PlantCategory` |
| Service | `plant-records.service.ts` | `PlantRecordsService` |
| Controller | `plant-records.controller.ts` | `PlantRecordsController` |
| Module | `plant-records.module.ts` | `PlantRecordsModule` |

## Schemas

- Always `@Schema({ timestamps: true })` on top-level documents.
- Always `@Schema({ _id: false })` on embedded subdocuments.
- Always export `type XDocument = HydratedDocument<X>`.
- Add `uuid` (unique, indexed) on syncable schemas.
- Field names must match Flutter Isar model field names exactly.

## DTOs

- Every field gets `@ApiProperty()`.
- Enums: `@IsEnum(MyEnum)` + `@ApiProperty({ enum: MyEnum })`.
- Nested: `@ValidateNested()` + `@Type(() => SubDto)`.
- Arrays: `@IsArray()` + `@ValidateNested({ each: true })`.
- Optional: `@IsOptional()` before other decorators.

## Error Handling

- Use NestJS exceptions: `NotFoundException`, `ConflictException`, `BadRequestException`.
- Never throw raw `Error` or return error objects.
- Never catch exceptions silently — let the global `AllExceptionsFilter` handle them.

## Queries

- Use `.lean()` for read-only queries.
- Implement pagination: `skip((page - 1) * limit).limit(limit)`.
- Use `.exec()` to get proper Promise typing.
