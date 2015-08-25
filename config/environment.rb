require 'sequel'

database_configuration = Configuration.database_configuration
Persistence::DatabaseManager.set_configuration(database_configuration)
database = Sequel.connect(Persistence::DatabaseManager.url(:test))
Sequel::Model.db = database
