# frozen_string_literal: true

require 'sequel'
require_relative 'logger'

DB_PATH = ENV.fetch('DATABASE_URL', 'sqlite://db/development.sqlite3')
DB = Sequel.connect(DB_PATH)

if ENV['RACK_ENV'] == 'development'
  sql_logger = Object.new
  sql_logger.define_singleton_method(:debug) { |msg| AppLogger.debug('sql', { query: msg }) }
  DB.loggers << sql_logger
end
