require 'spec_helper'

RSpec.describe Presenters::ItemPresenter do
  describe '.present' do
    it 'presents an item as a hash' do
      due_date = Time.now
      item = {
        id: 1234,
        description: 'the description',
        complete: false,
        due_date: due_date
      }

      presented_item = Presenters::ItemPresenter.present(item)

      expect(presented_item[:id]).to eq(1234)
      expect(presented_item[:description]).to eq('the description')
      expect(presented_item[:complete]).to eq(false)
      expect(presented_item[:dueDate]).to eq(due_date.iso8601)
    end
  end
end
