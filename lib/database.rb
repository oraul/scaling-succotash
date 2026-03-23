# frozen_string_literal: true

require 'sequel'

DB_PATH = ENV.fetch('DATABASE_URL', 'sqlite://db/development.sqlite3')
DB = Sequel.connect(DB_PATH)
