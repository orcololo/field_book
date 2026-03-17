# Field Book API

NestJS REST API with MongoDB for the Field Book herbarium application.

## Stack

- **NestJS** — Progressive Node.js framework
- **MongoDB** — NoSQL database (via Docker)
- **Mongoose** — ODM for MongoDB
- **Passport + JWT** — Authentication
- **class-validator / class-transformer** — DTO validation
- **Swagger** — API documentation
- **Helmet + Throttler** — Security
- **Terminus** — Health checks

## Quick Start

```bash
# 1. Start MongoDB via Docker
npm run docker:up

# 2. Install dependencies
npm install

# 3. Run in development mode
npm run start:dev
```

## Environment

Copy `.env.example` to `.env` and fill in the values. The defaults work out of the box with the Docker Compose setup.

## API Docs

Swagger UI available at `http://localhost:3000/api/docs` (dev mode only).

## Project Structure

```
src/
├── main.ts                 # Bootstrap & global config
├── app.module.ts           # Root module
├── config/                 # Env validation
├── database/               # Mongoose connection
├── health/                 # Health check endpoint
├── common/                 # Shared utilities
│   ├── decorators/         # @CurrentUser, @Roles
│   ├── filters/            # Global exception filter
│   ├── guards/             # RolesGuard
│   ├── interceptors/       # Logging, Transform
│   └── pipes/              # ParseObjectIdPipe
└── modules/
    ├── auth/               # JWT authentication
    │   ├── dto/
    │   ├── guards/
    │   ├── strategies/
    │   └── interfaces/
    └── users/              # User CRUD
        ├── dto/
        └── schemas/
```

## Scripts

| Command              | Description                     |
| -------------------- | ------------------------------- |
| `npm run start:dev`  | Dev server with hot reload      |
| `npm run build`      | Build for production            |
| `npm run start:prod` | Run production build            |
| `npm run test`       | Run unit tests                  |
| `npm run test:e2e`   | Run end-to-end tests            |
| `npm run docker:up`  | Start MongoDB + Mongo Express   |
| `npm run docker:down`| Stop Docker containers          |
| `npm run lint`       | Lint and fix code               |
