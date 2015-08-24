# The ToDo App

## Developer Setup

1. clone this repository to your local machine
1. install dependencies (`bundle install`)
1. copy the database configuration file (e.g. `cp config/database/database.yml.example config/database/database.yml`)
1. update your database configuration file to point to the SQLite data location (`:data_directory` entry in the configuration file)
1. run database migrations (`bundle exec rake db:migrate[test]`)
1. run tests (`bundle exec rspec`)

## Running the App Locally

1. ensure you have all dependencies (`bundle install`)
1. run the database migrations for your environment (`bundle exec rake db:migrate[ENVIRONMENT]`)
1. start the server in your enviroment (`bundle exec rake server:start[ENVIRONMENT]`)
