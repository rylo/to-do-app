module Presenters
  class ItemPresenter
    class << self

      def present(item)
        {
          description: item[:description],
          complete: item[:complete],
          dueDate: item[:due_date].iso8601
        }
      end

    end
  end
end
