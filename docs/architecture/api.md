# API Routes

> Keep this file updated when routes are added or changed.

## Current Routes

| Method | Path            | Auth | Description                                   |
|--------|-----------------|------|-----------------------------------------------|
| GET    | /health         | No   | Health check                                  |
| POST   | /users          | No   | Register — `{ name, email, password }`        |
| GET    | /users/:id      | No   | Get a user's public profile                   |
| POST   | /sessions       | No   | Log in — `{ email, password }` → `{ token }`  |
| DELETE | /sessions       | Yes  | Log out (invalidate token)                    |
| GET    | /articles       | No   | List articles (paginated, filterable by user) |
| GET    | /articles/:id   | No   | Get a single article                          |
| POST   | /articles       | Yes  | Create an article                             |
| PATCH  | /articles/:id   | Yes  | Update own article                            |
| DELETE | /articles/:id   | Yes  | Delete own article                            |

## Authentication

Write endpoints require: `Authorization: Bearer <token>`

## Query Params — GET /articles

| Param    | Default | Description                |
|----------|---------|----------------------------|
| page     | 1       | Page number                |
| per_page | 20      | Results per page (max 100) |
| user_id  | —       | Filter articles by author  |

## Conventions
- JSON responses only (`Content-Type: application/json`)
- Error shape: `{ "error": "message" }`
- Success shape varies per endpoint
- No logic in route handlers — delegate to `lib/services/`
