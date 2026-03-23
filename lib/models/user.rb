# frozen_string_literal: true

require 'bcrypt'

class User < Sequel::Model
  plugin :timestamps, update_on_create: true

  one_to_many :tokens
  one_to_many :articles

  def password=(plain)
    self.password_digest = BCrypt::Password.create(plain)
  end

  def authenticate?(plain)
    BCrypt::Password.new(password_digest) == plain
  end

  def to_public
    { id: id, name: name, email: email, created_at: created_at }
  end
end
