import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

export class GoogleLoginDto {
  @ApiProperty({ description: 'Google ID token from Flutter client' })
  @IsString()
  @IsNotEmpty()
  idToken: string;
}
