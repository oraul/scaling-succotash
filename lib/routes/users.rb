# frozen_string_literal: true

class App < Sinatra::Base
  post '/users' do
    data = JSON.parse(request.body.read)
    user = Services::RegisterUser.new(
      name: data['name'],
      email: data['email'],
      password: data['password']
    ).call
    status 201
    json user.to_public
  rescue ArgumentError => e
    halt 422, json(error: e.message)
  rescue Sequel::UniqueConstraintViolation
    halt 422, json(error: 'email already taken')
  end

  get '/users/:id' do
    user = User[params[:id].to_i]
    halt 404, json(error: 'user not found') unless user
    json user.to_public
  end
end
