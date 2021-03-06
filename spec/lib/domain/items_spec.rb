require 'spec_helper'
require 'domain/items'

RSpec.describe Domain::Items do
  describe '.fetch_all_for_user' do
    it 'fetches all persisted to-do items for a given user' do
      user_name = 'Gandalf the Grey'
      Persistence::UserAccessor.create(name: user_name)
      due_date = Time.now
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'save Middle Earth',
        complete: false,
        due_date: due_date
      })
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'meet Frodo at the Shire',
        complete: true,
        due_date: due_date
      })

      status, response = Domain::Items.fetch_all_for_user(user_name)

      expect(status).to eq(200)
      returned_items = response[:items]
      expect(returned_items.count).to eq(2)
      returned_item = returned_items.first
      expect(returned_item[:userName]).to eq(user_name)

      item_id = returned_item[:id]
      persisted_user = Persistence::ItemAccessor.find(item_id)
      expect(persisted_user).to_not be_nil
      expect(persisted_user[:user_name]).to eq(user_name)
    end

    it 'returns a 404 with empty octet if the user does not exist' do
      user_name = 'Sauron'
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'save Middle Earth',
        complete: false,
        due_date: Time.now
      })
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'meet Frodo at the Shire',
        complete: true,
        due_date: Time.now
      })

      status, response = Domain::Items.fetch_all_for_user(user_name)

      expect(status).to eq(404)
      expect(response).to eq({})
    end
  end

  describe '.fetch_incomplete_for_user' do
    it 'fetches all incomplete persisted to-do items for a given user' do
      user_name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: user_name)
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'become admiral',
        complete: true,
        due_date: Time.now
      })
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now
      })

      status, response = Domain::Items.fetch_incomplete_for_user(user_name)

      expect(status).to eq(200)
      items = response[:items]
      expect(items.size).to eq(1)
      expect(items.first[:description]).to eq('find a new home')
    end

    it 'returns a 404 if a user with the given username does not exist' do
      user_name = 'Admiral Adama'
      Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now
      })

      status, response = Domain::Items.fetch_incomplete_for_user(user_name)

      expect(status).to eq(404)
      expect(response).to eq({})
    end
  end
end
