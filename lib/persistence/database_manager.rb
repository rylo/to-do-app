require 'yaml'

module Persistence
  class DatabaseManager
    class << self

      def set_configuration(configuration_file)
        @configuration = nil
        @configuration_file = configuration_file
      end

      def url(environment)
        config = load_configuration[environment]
        "sqlite://#{config[:data_directory]}/#{config[:application]}_#{environment.to_s}.db"
      end

      private

      def load_configuration
        @configuration ||= YAML.load(@configuration_file)
      end

    end
  end
end
