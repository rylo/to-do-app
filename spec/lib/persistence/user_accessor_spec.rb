require 'spec_helper'
require 'persistence/user_accessor'

RSpec.describe Persistence::UserAccessor do
  before :example do
    @user_accessor = Persistence::UserAccessor.new(@database)
  end

  describe '.find' do
    it 'returns a persisted user by name' do
      name = 'Robert Baratheon'
      @user_accessor.create(name: name)

      user = @user_accessor.find(name)

      expect(user).to_not be_nil
      expect(user[:name]).to eq(name)
    end

    it 'returns nil if a user does not exist with the given name' do
      user = @user_accessor.find('Nobody')

      expect(user).to be_nil
    end
  end
end
