require 'sequel/model'

module Persistence
  class UserAccessor < Sequel::Model
    class << self

      def create(attributes)
        table.insert(attributes)
      end

      def find(id)
        table.where(id: id).first
      end

      def find_by_name(name)
        table.where(name: name).first
      end

      private

      def table
        db[:users]
      end

    end
  end
end
