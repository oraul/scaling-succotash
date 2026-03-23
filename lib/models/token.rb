# frozen_string_literal: true

require 'securerandom'

class Token < Sequel::Model
  many_to_one :user

  def self.generate_for(user)
    create(user_id: user.id, value: SecureRandom.hex(32))
  end
end
