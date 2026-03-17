import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { OAuth2Client } from 'google-auth-library';
import { UsersService } from '../users/users.service';
import { LoginDto, RefreshTokenDto, GoogleLoginDto } from './dto';
import { JwtPayload, TokenResponse } from './interfaces/jwt-payload.interface';
import { CreateUserDto } from '../users/dto';

@Injectable()
export class AuthService {
  private readonly googleClient: OAuth2Client;

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {
    this.googleClient = new OAuth2Client(
      this.configService.get<string>('GOOGLE_CLIENT_ID'),
    );
  }

  async register(createUserDto: CreateUserDto): Promise<TokenResponse> {
    const user = await this.usersService.create(createUserDto);
    const tokens = await this.generateTokens({
      sub: user.id,
      email: user.email,
      role: user.role,
    });
    await this.usersService.setRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async login(loginDto: LoginDto): Promise<TokenResponse> {
    const user = await this.usersService.findByEmail(loginDto.email);
    if (!user || !user.isActive) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (!user.password) {
      throw new UnauthorizedException('This account uses Google sign-in');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.password, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const tokens = await this.generateTokens({
      sub: user.id,
      email: user.email,
      role: user.role,
    });
    await this.usersService.setRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async refreshTokens(refreshTokenDto: RefreshTokenDto): Promise<TokenResponse> {
    try {
      const payload = this.jwtService.verify<JwtPayload>(refreshTokenDto.refreshToken, {
        secret: this.configService.get<string>('JWT_SECRET'),
      });

      const user = await this.usersService.findById(payload.sub);
      if (!user || !user.refreshToken) {
        throw new ForbiddenException('Access denied');
      }

      const isTokenValid = await bcrypt.compare(refreshTokenDto.refreshToken, user.refreshToken);
      if (!isTokenValid) {
        throw new ForbiddenException('Access denied');
      }

      const tokens = await this.generateTokens({
        sub: user.id,
        email: user.email,
        role: user.role,
      });
      await this.usersService.setRefreshToken(user.id, tokens.refreshToken);
      return tokens;
    } catch {
      throw new ForbiddenException('Access denied');
    }
  }

  async googleLogin(googleLoginDto: GoogleLoginDto): Promise<TokenResponse> {
    const ticket = await this.googleClient.verifyIdToken({
      idToken: googleLoginDto.idToken,
      audience: this.configService.get<string>('GOOGLE_CLIENT_ID'),
    });

    const payload = ticket.getPayload();
    if (!payload || !payload.email) {
      throw new UnauthorizedException('Invalid Google token');
    }

    const user = await this.usersService.findOrCreateByGoogle(
      payload.sub,
      payload.email,
      payload.name || payload.email.split('@')[0],
      payload.picture,
    );

    if (!user.isActive) {
      throw new UnauthorizedException('Account is deactivated');
    }

    const tokens = await this.generateTokens({
      sub: user.id,
      email: user.email,
      role: user.role,
    });
    await this.usersService.setRefreshToken(user.id, tokens.refreshToken);
    return tokens;
  }

  async logout(userId: string): Promise<void> {
    await this.usersService.setRefreshToken(userId, null);
  }

  private async generateTokens(payload: JwtPayload): Promise<TokenResponse> {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync({ ...payload } as Record<string, unknown>, {
        expiresIn: this.configService.get<string>('JWT_EXPIRATION', '1d') as any,
      }),
      this.jwtService.signAsync({ ...payload } as Record<string, unknown>, {
        expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRATION', '7d') as any,
      }),
    ]);
    return { accessToken, refreshToken };
  }
}
