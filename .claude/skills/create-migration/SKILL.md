---
name: create-migration
description: |
  Creates a Sequel migration file following project conventions.
  Use when adding, modifying, or removing DB tables or columns.
  Triggers on: "add column", "create table", "drop table", "migration",
  "schema change", "rename column", "add index", "foreign key".
---

## Steps

1. List existing files in `db/migrate/` to find the next sequential number
2. Name the file: `db/migrate/NNN_short_description.rb` (zero-pad to 3 digits)
3. Use `Sequel.migration do / change do` pattern
4. Prefer `change` over `up`/`down` unless rollback logic is non-trivial
5. Run `rake db:migrate` and confirm output is clean
6. Update `docs/architecture/models.md` if table structure changed

## Example

```ruby
Sequel.migration do
  change do
    add_column :users, :role, String, default: 'user', null: false
  end
end
```

## Create table example

```ruby
Sequel.migration do
  change do
    create_table :posts do
      primary_key :id
      String :title, null: false
      Text :body
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      foreign_key :user_id, :users, null: false
    end
  end
end
```

## Never
- Never use raw SQL — Sequel DSL only
- Never modify a migration that has already been committed/run — create a new one
- Never skip running `rake db:migrate` after creating the file
