# frozen_string_literal: true

class App < Sinatra::Base
  post '/sessions' do
    data = JSON.parse(request.body.read)
    token = Services::AuthenticateUser.new(
      email: data['email'],
      password: data['password']
    ).call
    status 201
    json token: token.value
  rescue ArgumentError => e
    halt 401, json(error: e.message)
  end

  delete '/sessions' do
    authenticate!
    Token.first(value: bearer_token)&.destroy
    status 204
  end
end
