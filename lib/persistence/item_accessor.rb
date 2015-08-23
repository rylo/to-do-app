module Persistence
  class ItemAccessor

    def initialize(database)
      @table = database[:items]
    end

    def create(attributes)
      @table.insert(attributes)
    end

    def all(user_name)
      @table.where(user_name: user_name)
    end

  end
end
