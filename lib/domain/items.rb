require 'persistence/item_accessor'
require 'persistence/user_accessor'
require 'presenters/item_presenter'

module Domain
  class Items
    class << self

      def fetch_all_for_user(user_name)
        user = Persistence::UserAccessor.find_by_name(user_name)

        return [404, {}] if user.nil?

        items = Persistence::ItemAccessor.all(user_name)
        [200, present_items(items)]
      end

      private

      def present_items(items)
        presented_items = items.map do |item|
          Presenters::ItemPresenter.present(item)
        end

        {items: presented_items}
      end

    end
  end
end
