# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'
require_relative 'lib/database'

class App < Sinatra::Base
  configure do
    set :show_exceptions, false
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
