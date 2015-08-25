require 'spec_helper'
require 'application'
require 'requestable'

RSpec.describe 'items endpoints', integration: true do
  include Requestable

  before :context do
    Thread.new do
      Application.run!
    end

    sleep 0.5
  end

  describe 'POST items' do
    it 'creates a new item and returns a 200' do
      name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: name)
      due_date = Time.now
      response = post "items", {
        item: {
          userName: name,
          description: 'the description!',
          complete: true,
          dueDate: due_date
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
      response = post "items", {
        item: {
          userName: 'Nobody',
          description: 'the description!',
          complete: true,
          dueDate: Time.now
        }
      }

      expect(response.status).to eq(404)
    end

    it 'returns a 400 if the item is missing required fields' do
      name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: name)

      response = post "items", {item: {}}

      expect(response.status).to eq(400)
      errors = JSON.parse(response.body)['errors']
      expect(errors).to match_array(['userName required', 'description required', 'complete required', 'dueDate required'])
    end
  end

  describe 'PUT /items/:id' do
    it 'returns a 200 with the presented, updated item' do
      user_name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: user_name)
      item_id = Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'find a new home',
        complete: false,
        due_date: Time.now - 1000
      })
      updated_due_date = Time.now
      response = put "items/#{item_id}", {
        item: {
          userName: user_name,
          description: 'the description!',
          complete: true,
          dueDate: updated_due_date
        }
      }

      expect(response.status).to eq(200)
      returned_item = JSON.parse(response.body)['item']
      expect(returned_item['userName']).to eq(user_name)
      expect(returned_item['description']).to eq('the description!')
      expect(returned_item['complete']).to eq(true)
      expect(returned_item['dueDate']).to eq(updated_due_date.iso8601)

      persisted_items = Persistence::ItemAccessor.all(user_name).all
      expect(persisted_items.size).to eq(1)
      persisted_item = persisted_items.first
      expect(persisted_item[:description]).to eq('the description!')
      expect(persisted_item[:complete]).to eq(true)
      expect(persisted_item[:due_date].iso8601).to eq(updated_due_date.iso8601)
    end

    it 'returns a 404 if the given item does not exist' do
      response = put "items/0000", {
        item: {
          userName: 'Darth Sidious',
          description: 'the description!',
          complete: true,
          dueDate: Time.now
        }
      }

      expect(response.status).to eq(404)
    end
  end

  describe 'PUT /items/:id/complete' do
    it 'sets the complete field for the given item to true' do
      user_name = 'Admiral Adama'
      Persistence::UserAccessor.create(name: user_name)
      due_date = Time.now
      item_id = Persistence::ItemAccessor.create({
        user_name: user_name,
        description: 'find a new home',
        complete: false,
        due_date: due_date
      })

      response = put "items/#{item_id}/complete", {}

      expect(response.status).to eq(200)
      returned_item = JSON.parse(response.body)['item']
      expect(returned_item['userName']).to eq(user_name)
      expect(returned_item['description']).to eq('find a new home')
      expect(returned_item['complete']).to eq(true)
      expect(returned_item['dueDate']).to eq(due_date.iso8601)

      persisted_items = Persistence::ItemAccessor.all(user_name).all
      expect(persisted_items.size).to eq(1)
      persisted_item = persisted_items.first
      expect(persisted_item[:description]).to eq('find a new home')
      expect(persisted_item[:complete]).to eq(true)
      expect(persisted_item[:due_date].iso8601).to eq(due_date.iso8601)
    end

    it 'returns a 404 if an item with the given id does not exist' do
      response = put "items/000/complete", {}

      expect(response.status).to eq(404)
    end
  end
end
