$:.unshift File.expand_path('../config/', File.dirname(__FILE__))

require 'sequel'
require 'configuration'
require 'persistence/database_manager'

Sequel::Model.plugin :insert_returning_select
database_configuration = Configuration.database_configuration
Persistence::DatabaseManager.set_configuration(database_configuration)
database = Sequel.connect(Persistence::DatabaseManager.url(:test))
Sequel::Model.db = database

RSpec.configure do |config|
  config.before :example do
    Sequel::Model.db.run('DELETE FROM items')
    Sequel::Model.db.run('DELETE FROM users')
  end
end
