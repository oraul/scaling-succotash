# frozen_string_literal: true

module Services
  class RegisterUser
    def initialize(name:, email:, password:)
      @name = name
      @email = email
      @password = password
    end

    def call
      raise ArgumentError, 'name is required' if @name.to_s.strip.empty?
      raise ArgumentError, 'email is required' if @email.to_s.strip.empty?
      raise ArgumentError, 'password is required' if @password.to_s.strip.empty?

      user = User.new(name: @name, email: @email)
      user.password = @password
      user.save
      user
    end
  end
end
