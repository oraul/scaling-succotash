# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      foreign_key :user_id, :users, null: false
      String :title, null: false
      String :body, null: false, text: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
