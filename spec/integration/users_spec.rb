require 'spec_helper'
require 'application'
require 'requestable'

RSpec.describe 'users endpoints', integration: true do
  include Requestable

  before :context do
    Thread.new do
      Application.initialize!
      Application.run!
    end

    sleep 0.5
  end

  describe 'GET /users/:username/items' do
    it 'returns a 200 with the persisted items for a given user' do
      name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: name)
      due_date = Time.now + (60 * 60 * 24 * 7)
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'find a new home',
        complete: false,
        due_date: due_date
      })
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'become admiral',
        complete: true,
        due_date: due_date
      })

      response = get "users/#{name}/items"

      expect(response.status).to eq(200)
      items = JSON.parse(response.body)['items']
      expect(items.size).to eq(2)
      item = items.first
      expect(item['description']).to eq('find a new home')
      expect(item['complete']).to eq(false)
      expect(item['dueDate']).to eq(due_date.iso8601)
    end

    it 'returns a 404 if a user with the given username does not exist' do
      name = 'Admiral Adama'
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now
      })

      response = get "items/#{name}"

      expect(response.status).to eq(404)
    end
  end

  describe 'GET /users/username/incomplete' do
    it 'returns a 200 with the persisted incomplete items for a given user' do
      name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: name)
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'become admiral',
        complete: true,
        due_date: Time.now
      })
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now
      })

      response = get "users/#{name}/items/incomplete"

      expect(response.status).to eq(200)
      items = JSON.parse(response.body)['items']
      expect(items.size).to eq(1)
      item = items.first
      expect(item['description']).to eq('find a new home')
    end

    it 'returns a 404 if a user with the given username does not exist' do
      name = 'Admiral Adama'
      Persistence::ItemAccessor.create({
        user_name: name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now
      })

      response = get "items/#{name}/incomplete"

      expect(response.status).to eq(404)
    end
  end

  describe 'POST items' do
    it 'returns a 200 with the presented, persisted item' do
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
      response = post "items/Nobody", {
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