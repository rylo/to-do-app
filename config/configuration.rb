class Configuration
  class << self

    def database_configuration
      File.open(
        File.expand_path('../database/database.yml', __FILE__)
      )
    end

  end
end
