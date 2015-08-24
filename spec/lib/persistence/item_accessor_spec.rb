require 'spec_helper'
require 'persistence/item_accessor'

RSpec.describe Persistence::ItemAccessor do
  describe '.find' do
    it 'returns the persisted to-do items with the given id' do
      item_id = described_class.create({
        user_name: 'Darth Vader',
        description: 'give someone a hug',
        due_date: Time.now,
        complete: false
      })

      item = described_class.find(item_id)

      expect(item).to_not be_nil
      expect(item[:description]).to eq('give someone a hug')
    end

    it 'returns nil if an item with the given id does not exist' do
      item = described_class.find(0000000)

      expect(item).to be_nil
    end
  end

  describe '.update' do
    it 'updates an item' do
      item_id = described_class.create({
        user_name: 'Darth Vader',
        description: 'give someone a hug',
        due_date: Time.now,
        complete: false
      })
      item = described_class.find(item_id)

      updated_due_date = Time.now + 1000
      updated_item = described_class.update(item_id, {
        user_name: 'Darth Maul',
        description: 'give someone a pat on the back',
        due_date: updated_due_date,
        complete: true
      })

      updated_item = described_class.find(item_id)
      expect(updated_item[:description]).to eq('give someone a pat on the back')
      expect(updated_item[:due_date]).to eq(updated_due_date)
      expect(updated_item[:user_name]).to eq('Darth Maul')
      expect(updated_item[:complete]).to eq(true)
    end

    it 'returns nil if an item with the given id does not exist' do
      item = described_class.find(0000000)

      expect(item).to be_nil
    end
  end

  describe '.all' do
    it 'returns all persisted to-do items for the given user' do
      user_name = 'Robert Baratheon'
      described_class.create({
        user_name: user_name,
        description: 'sit on the Iron Throne',
        due_date: Time.now,
        complete: true
      })
      described_class.create({
        user_name: 'Stannis Baratheon',
        description: 'touch the Iron Throne',
        due_date: Time.now,
        complete: false
      })

      incomplete_items = described_class.all(user_name)

      expect(incomplete_items.count).to eq(1)
      expect(incomplete_items.first[:description]).to eq('sit on the Iron Throne')
    end
  end

  describe '.incomplete' do
    it 'returns all incomplete persisted to-do items for the given user' do
      user_name = 'Robert Baratheon'
      described_class.create({
        user_name: user_name,
        description: 'sit on the Iron Throne',
        due_date: Time.now,
        complete: true
      })
      described_class.create({
        user_name: user_name,
        description: 'get along with Cersei',
        due_date: Time.now,
        complete: false
      })

      incomplete_items = described_class.incomplete(user_name)

      expect(incomplete_items.count).to eq(1)
      expect(incomplete_items.first[:description]).to eq('get along with Cersei')
    end
  end
end
