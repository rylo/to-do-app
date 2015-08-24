module Presenters
  class ItemPresenter
    class << self

      def present(item)
        {
          id: item[:id],
          userName: item[:user_name],
          description: item[:description],
          complete: item[:complete],
          dueDate: item[:due_date].iso8601
        }
      end

    end
  end
end
