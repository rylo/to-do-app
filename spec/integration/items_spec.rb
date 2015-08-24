require 'spec_helper'
require 'application'
require 'requestable'

RSpec.describe 'items endpoints', integration: true do
  include Requestable

  before :context do
    Thread.new do
      Application.initialize!
      Application.run!
    end

    sleep 0.5
  end

  describe 'POST items' do
    it 'creates a new item and returns a 200' do
      name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: name)
      due_date = Time.now
      response = post "items/#{name}", {
        item: {
          description: 'the description!',
          complete: true,
          due_date: due_date
        }
      }

      expect(response.status).to eq(200)
      returned_item = JSON.parse(response.body)['item']
      expect(returned_item['userName']).to eq(name)
      expect(returned_item['description']).to eq('the description!')
      expect(returned_item['complete']).to eq(true)
      expect(returned_item['dueDate']).to eq(due_date.iso8601)

      persisted_items = Persistence::ItemAccessor.all(name).all
      expect(persisted_items.size).to eq(1)
      persisted_item = persisted_items.first
      expect(persisted_item[:description]).to eq('the description!')
      expect(persisted_item[:complete]).to eq(true)
      expect(persisted_item[:due_date].iso8601).to eq(due_date.iso8601)
    end

    it 'returns a 404 if a user with the given username does not exist' do
      response = post "users/Nobody/items", {
        item: {
          description: 'the description!',
          complete: true,
          due_date: Time.now
        }
      }

      expect(response.status).to eq(404)
    end
  end
end
