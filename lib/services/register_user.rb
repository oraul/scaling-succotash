# frozen_string_literal: true

require_relative '../concerns/loggable'

module Services
  class RegisterUser
    include Concerns::Loggable

    def initialize(name:, email:, password:)
      @name = name
      @email = email
      @password = password
    end

    def call
      validate!
      user = User.new(name: @name, email: @email)
      user.password = @password
      user.save
      log_info('user.registered', { user_id: user.id, email: user.email })
      user
    end

    private

    def validate!
      raise ArgumentError, 'name is required' if @name.to_s.strip.empty?
      raise ArgumentError, 'email is required' if @email.to_s.strip.empty?
      raise ArgumentError, 'password is required' if @password.to_s.strip.empty?
    end
  end
end
