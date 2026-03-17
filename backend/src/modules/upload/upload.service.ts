import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  S3Client,
  PutObjectCommand,
  DeleteObjectCommand,
  GetObjectCommand,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import sharp from 'sharp';
import { randomUUID } from 'crypto';

export interface UploadResult {
  key: string;
  thumbnailKey: string;
  url: string;
  thumbnailUrl: string;
}

@Injectable()
export class UploadService {
  private readonly s3: S3Client;
  private readonly bucket: string;
  private readonly publicUrl?: string;

  constructor(private readonly configService: ConfigService) {
    const accountId = this.configService.getOrThrow<string>('R2_ACCOUNT_ID');
    this.bucket = this.configService.get<string>('R2_BUCKET_NAME', 'fieldbook');
    this.publicUrl = this.configService.get<string>('R2_PUBLIC_URL');

    this.s3 = new S3Client({
      region: 'auto',
      endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: this.configService.getOrThrow<string>('R2_ACCESS_KEY_ID'),
        secretAccessKey: this.configService.getOrThrow<string>('R2_SECRET_ACCESS_KEY'),
      },
    });
  }

  async uploadImage(
    file: Express.Multer.File,
    userId: string,
    registryId?: string,
  ): Promise<UploadResult> {
    const allowedMimes = ['image/jpeg', 'image/png', 'image/webp'];
    if (!allowedMimes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPEG, PNG, and WebP images are allowed');
    }

    const uuid = randomUUID();
    const prefix = registryId
      ? `images/${userId}/${registryId}`
      : `images/${userId}`;
    const key = `${prefix}/${uuid}.jpg`;
    const thumbnailKey = `thumbnails/${userId}/${uuid}.jpg`;

    const compressed = await sharp(file.buffer)
      .resize(1920, 1920, { fit: 'inside', withoutEnlargement: true })
      .jpeg({ quality: 80 })
      .toBuffer();

    const thumbnail = await sharp(file.buffer)
      .resize(300, 300, { fit: 'inside', withoutEnlargement: true })
      .jpeg({ quality: 60 })
      .toBuffer();

    await Promise.all([
      this.s3.send(
        new PutObjectCommand({
          Bucket: this.bucket,
          Key: key,
          Body: compressed,
          ContentType: 'image/jpeg',
        }),
      ),
      this.s3.send(
        new PutObjectCommand({
          Bucket: this.bucket,
          Key: thumbnailKey,
          Body: thumbnail,
          ContentType: 'image/jpeg',
        }),
      ),
    ]);

    return {
      key,
      thumbnailKey,
      url: this.buildUrl(key),
      thumbnailUrl: this.buildUrl(thumbnailKey),
    };
  }

  async deleteImage(key: string): Promise<void> {
    const thumbnailKey = key.replace(/^images\//, 'thumbnails/');
    await Promise.all([
      this.s3.send(new DeleteObjectCommand({ Bucket: this.bucket, Key: key })),
      this.s3.send(new DeleteObjectCommand({ Bucket: this.bucket, Key: thumbnailKey })),
    ]);
  }

  async getSignedUrl(key: string, expiresIn = 3600): Promise<string> {
    const command = new GetObjectCommand({ Bucket: this.bucket, Key: key });
    return getSignedUrl(this.s3, command, { expiresIn });
  }

  private buildUrl(key: string): string {
    if (this.publicUrl) {
      return `${this.publicUrl}/${key}`;
    }
    return key;
  }
}
