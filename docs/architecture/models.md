# DB Models

> Keep this file updated after every migration.

## Tables

### users

| Column          | Type     | Constraints        |
|-----------------|----------|--------------------|
| id              | integer  | PK, auto-increment |
| name            | string   | NOT NULL           |
| email           | string   | NOT NULL, UNIQUE   |
| password_digest | string   | NOT NULL           |
| created_at      | datetime |                    |
| updated_at      | datetime |                    |

### tokens

| Column     | Type     | Constraints              |
|------------|----------|--------------------------|
| id         | integer  | PK, auto-increment       |
| user_id    | integer  | FK → users, NOT NULL     |
| value      | string   | NOT NULL, UNIQUE         |
| created_at | datetime |                          |

### articles

| Column     | Type     | Constraints              |
|------------|----------|--------------------------|
| id         | integer  | PK, auto-increment       |
| user_id    | integer  | FK → users, NOT NULL     |
| title      | string   | NOT NULL                 |
| body       | text     | NOT NULL                 |
| created_at | datetime |                          |
| updated_at | datetime |                          |

## Conventions
- All tables use `id` as integer primary key
- `created_at` / `updated_at` on every table
- Foreign keys named `<table_singular>_id`
- Soft deletes via `deleted_at` column (when needed)
