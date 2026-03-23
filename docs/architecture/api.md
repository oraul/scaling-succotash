# API Routes

> Keep this file updated when routes are added or changed.

## Current Routes

| Method | Path      | Description        |
|--------|-----------|--------------------|
| GET    | /health   | Health check       |

## Conventions
- JSON responses only (`Content-Type: application/json`)
- Error shape: `{ "error": "message" }`
- Success shape varies per endpoint
- No logic in route handlers — delegate to `lib/services/`
