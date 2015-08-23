require 'spec_helper'
require 'persistence/database_manager'

RSpec.describe Persistence::DatabaseManager do
  before :example do
    configuration_file = <<-YAML
      :test:
        :application: 'to-do-app'
        :data_directory: 'some-file-path'
    YAML

    Persistence::DatabaseManager.set_configuration(configuration_file)
  end

  describe '.url' do
    it 'constructs a SQLite URL from the given configuration' do
      url = Persistence::DatabaseManager.url(:test)

      expect(url).to eq('sqlite://some-file-path/to-do-app_test.db')
    end
  end

  describe '.set_configuration' do
    it 'sets the global database configuration' do
      configuration_file = <<-YAML
        :arbitrary_environment:
          :application: 'some-other-application'
          :data_directory: 'some-other-file-path'
      YAML

      Persistence::DatabaseManager.set_configuration(configuration_file)
      url = Persistence::DatabaseManager.url(:arbitrary_environment)
      expect(url).to eq('sqlite://some-other-file-path/some-other-application_arbitrary_environment.db')
    end
  end
end
