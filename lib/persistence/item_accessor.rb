require 'sequel/model'

module Persistence
  class ItemAccessor < Sequel::Model
    class << self

      def find(item_id)
        table.where(id: item_id).limit(1).first
      end

      def create(attributes)
        table.insert(attributes)
      end

      def all(user_name)
        table.where(user_name: user_name)
      end

      def incomplete(user_name)
        table.where(user_name: user_name, complete: false)
      end

      private

      def table
        db[:items]
      end

    end
  end
end
