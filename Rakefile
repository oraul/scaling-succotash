# frozen_string_literal: true

require 'fileutils'
require 'sequel'
require 'rspec/core/rake_task'

DB_PATH = ENV.fetch('DATABASE_URL', 'sqlite://db/development.sqlite3')

namespace :db do
  desc 'Run pending migrations'
  task :migrate do
    db = Sequel.connect(DB_PATH)
    Sequel::Migrator.run(db, 'db/migrate')
    puts 'Migrations complete.'
  end

  desc 'Rollback last migration'
  task :rollback do
    db = Sequel.connect(DB_PATH)
    current = Sequel::Migrator.run(db, 'db/migrate', target: 0)
    puts "Rolled back to version #{current}."
  end

  desc 'Drop and recreate database'
  task :reset do
    db_file = DB_PATH.sub('sqlite://', '')
    FileUtils.rm_f(db_file)
    Rake::Task['db:migrate'].invoke
    puts 'Database reset.'
  end
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
