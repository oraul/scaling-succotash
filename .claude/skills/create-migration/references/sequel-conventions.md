# Sequel Migration Conventions

## Column Types
- `String` → VARCHAR(255)
- `Text`   → TEXT (use for long content)
- `Integer`, `Bignum`
- `Float`, `BigDecimal`
- `DateTime`, `Date`, `Time`
- `TrueClass` → BOOLEAN
- `File`   → BLOB

## Common Options
```ruby
String :name, null: false, default: ''
Integer :count, default: 0
DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
```

## Indexes
```ruby
add_index :users, :email, unique: true
add_index :posts, [:user_id, :created_at]
```

## Foreign Keys
```ruby
foreign_key :user_id, :users, null: false, on_delete: :cascade
```

## Rollback-aware up/down (when needed)
```ruby
Sequel.migration do
  up do
    add_column :users, :legacy_id, Integer
  end
  down do
    drop_column :users, :legacy_id
  end
end
```
