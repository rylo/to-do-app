require 'persistence/user_accessor'
require 'presenters/user_presenter'

module Domain
  class Users
    class << self

      def create(attributes)
        if !(attributes.keys == ['name'])
          return [400, { errors: ['name required'] }]
        end

        user_id = Persistence::UserAccessor.create(attributes)
        user = Persistence::UserAccessor.find(user_id)
        [200, present_user(user)]
      end

      private

      def present_user(user)
        { user: Presenters::UserPresenter.present(user) }
      end

    end
  end
end
