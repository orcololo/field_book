import * as Joi from 'joi';

export const envValidationSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
  PORT: Joi.number().default(3000),
  API_PREFIX: Joi.string().default('api'),

  MONGO_HOST: Joi.string().required(),
  MONGO_PORT: Joi.number().default(27017),
  MONGO_USERNAME: Joi.string().required(),
  MONGO_PASSWORD: Joi.string().required(),
  MONGO_DATABASE: Joi.string().required(),

  JWT_SECRET: Joi.string().required().min(16),
  JWT_EXPIRATION: Joi.string().default('1d'),
  JWT_REFRESH_EXPIRATION: Joi.string().default('7d'),

  THROTTLE_TTL: Joi.number().default(60000),
  THROTTLE_LIMIT: Joi.number().default(100),

  GOOGLE_CLIENT_ID: Joi.string().required(),

  R2_ACCOUNT_ID: Joi.string().required(),
  R2_ACCESS_KEY_ID: Joi.string().required(),
  R2_SECRET_ACCESS_KEY: Joi.string().required(),
  R2_BUCKET_NAME: Joi.string().default('fieldbook'),
  R2_PUBLIC_URL: Joi.string().optional(),
});
