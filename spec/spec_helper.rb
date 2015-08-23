$:.unshift File.expand_path('../config/', File.dirname(__FILE__))

require 'sequel'
require 'configuration'
require 'persistence/database_manager'

RSpec.configure do |config|
  config.before :example do
    database_configuration = Configuration.database_configuration
    Persistence::DatabaseManager.set_configuration(database_configuration)
    @database = Sequel.connect(Persistence::DatabaseManager.url(:test))
    @database.run('DELETE FROM items')
    @database.run('DELETE FROM users')
  end
end
