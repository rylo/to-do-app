require 'sequel/model'

module Persistence
  class UserAccessor < Sequel::Model
    class << self

      def create(attributes)
        table.insert(attributes)
      end

      def find(user_name)
        table.where(name: user_name).first
      end

      private

      def table
        db[:users]
      end

    end
  end
end
