module Persistence
  class UserAccessor

    def initialize(database)
      @table = database[:users]
    end

    def create(attributes)
      @table.insert(attributes)
    end

    def find(user_name)
      @table.where(name: user_name).first
    end

  end
end
