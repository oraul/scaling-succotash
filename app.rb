# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sinatra/json'
require_relative 'lib/logger'
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
    set :logging, nil
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

  before do
    @_request_started_at = Time.now
  end

  after do
    duration_ms = ((Time.now - @_request_started_at) * 1000).round
    AppLogger.info('request', {
                     method: request.request_method,
                     path: request.path_info,
                     status: response.status,
                     duration_ms: duration_ms,
                     user_id: current_user&.id
                   })
  end

  get '/health' do
    json status: 'ok'
  end

  not_found do
    json error: 'not found'
  end

  error do
    e = env['sinatra.error']
    AppLogger.error('unhandled_error', { class: e.class.name, message: e.message })
    json error: e.message
  end
end

require_relative 'lib/routes/users'
require_relative 'lib/routes/sessions'
require_relative 'lib/routes/articles'
