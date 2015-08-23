require 'spec_helper'
require 'persistence/item_accessor'

RSpec.describe Persistence::ItemAccessor do
  before :example do
    @item_accessor = Persistence::ItemAccessor.new(@database)
  end

  describe '.all' do
    it 'returns all persisted to-do items for the given user' do
      user_name = 'Robert Baratheon'
      @item_accessor.create({
        user_name: user_name,
        description: 'sit on the Iron Throne',
        due_date: Time.now,
        complete: true
      })
      @item_accessor.create({
        user_name: 'Stannis Baratheon',
        description: 'touch the Iron Throne',
        due_date: Time.now,
        complete: false
      })

      incomplete_items = @item_accessor.all(user_name)

      expect(incomplete_items.count).to eq(1)
      expect(incomplete_items.first[:description]).to eq('sit on the Iron Throne')
    end
  end
end
