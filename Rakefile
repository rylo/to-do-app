$:.unshift File.expand_path('./config/', File.dirname(__FILE__))
$:.unshift File.expand_path('./lib/', File.dirname(__FILE__))

require 'persistence/database_manager'
require 'configuration'

namespace :db do
  desc 'Run existing migrations'
  task :migrate, [:environment] do |task, args|
    environment = args[:environment].to_sym

    puts "Running database migrations for '#{environment}' environment..."

    database_configuration = Configuration.database_configuration
    Persistence::DatabaseManager.set_configuration(database_configuration)
    command = "sequel -m config/database/migrations #{Persistence::DatabaseManager.url(environment)}"
    puts `#{command}`
  end
end

namespace :server do
  desc 'Start the application'
  task :start, [:environment] do |task, args|
    require 'application'
    environment = args[:environment].to_sym

    puts "Starting application in '#{environment}' environment..."

    Application.run!
  end
end
