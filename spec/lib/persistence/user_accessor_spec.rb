require 'spec_helper'
require 'persistence/user_accessor'

RSpec.describe Persistence::UserAccessor do
  describe '.find' do
    it 'returns a persisted user by id' do
      user_id = described_class.create(name: 'Luke Skywalker')

      user = described_class.find(user_id)

      expect(user).to_not be_nil
      expect(user[:name]).to eq('Luke Skywalker')
    end

    it 'returns nil if a user does not exist with the given id' do
      user = described_class.find(0000)

      expect(user).to be_nil
    end
  end

  describe '.find_by_name' do
    it 'returns a persisted user by name' do
      name = 'Robert Baratheon'
      described_class.create(name: name)

      user = described_class.find_by_name(name)

      expect(user).to_not be_nil
      expect(user[:name]).to eq(name)
    end

    it 'returns nil if a user does not exist with the given name' do
      user = described_class.find_by_name('Nobody')

      expect(user).to be_nil
    end
  end
end
