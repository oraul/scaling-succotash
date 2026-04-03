# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'

class App < Sinatra::Base
  configure do
    set :show_exceptions, false
    set :logging, nil
  end

  configure :test do
    set :protection, false
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
