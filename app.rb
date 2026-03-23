# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sinatra/json'
require_relative 'lib/database'
require_relative 'lib/models/user'
require_relative 'lib/models/token'
require_relative 'lib/models/article'
require_relative 'lib/services/register_user'
require_relative 'lib/services/authenticate_user'
require_relative 'lib/services/list_articles'
require_relative 'lib/services/create_article'
require_relative 'lib/services/update_article'
require_relative 'lib/services/delete_article'

class App < Sinatra::Base
  configure do
    set :show_exceptions, false
  end

  configure :test do
    set :protection, false
  end

  helpers do
    def bearer_token
      request.env['HTTP_AUTHORIZATION']&.sub('Bearer ', '')
    end

    def authenticate!
      token = bearer_token
      halt 401, json(error: 'unauthorized') unless token
      @current_user = Token.first(value: token)&.user
      halt 401, json(error: 'unauthorized') unless @current_user
    end

    attr_reader :current_user
  end

  get '/health' do
    json status: 'ok'
  end

  not_found do
    json error: 'not found'
  end

  error do
    json error: env['sinatra.error'].message
  end
end

require_relative 'lib/routes/users'
require_relative 'lib/routes/sessions'
require_relative 'lib/routes/articles'
