# frozen_string_literal: true

class Article < Sequel::Model
  plugin :timestamps, update_on_create: true

  many_to_one :user

  def to_h
    {
      id: id,
      user_id: user_id,
      title: title,
      body: body,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
