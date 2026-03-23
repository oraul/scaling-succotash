# frozen_string_literal: true

module Services
  class AuthenticateUser
    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      user = User.first(email: @email)
      raise ArgumentError, 'invalid credentials' unless user&.authenticate?(@password)

      Token.generate_for(user)
    end
  end
end
