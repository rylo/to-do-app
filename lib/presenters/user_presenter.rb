module Presenters
  class UserPresenter
    class << self

      def present(user)
        {
          id: user[:id],
          name: user[:name]
        }
      end

    end
  end
end
