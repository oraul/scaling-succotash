# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:tokens) do
      primary_key :id
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      String :value, null: false, unique: true
      DateTime :created_at
    end
  end
end
