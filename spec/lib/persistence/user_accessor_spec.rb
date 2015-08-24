require 'spec_helper'
require 'persistence/user_accessor'

RSpec.describe Persistence::UserAccessor do
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
