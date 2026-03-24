# frozen_string_literal: true

require_relative '../concerns/loggable'

module Services
  class AuthenticateUser
    include Concerns::Loggable

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      user = User.first(email: @email)
      raise ArgumentError, 'invalid credentials' unless user&.authenticate?(@password)

      token = Token.generate_for(user)
      log_info('user.authenticated', { user_id: user.id })
      token
    end
  end
end
