require 'spec_helper'
require 'domain/users'

RSpec.describe Domain::Users do
  describe '.create' do
    it 'creates a user' do
      attributes = {
        'name' => 'Frodo Baggins'
      }

      status, response = Domain::Users.create(attributes)

      expect(status).to eq(200)
      returned_user = response[:user]
      expect(returned_user[:name]).to eq('Frodo Baggins')

      user_id = returned_user[:id]
      persisted_user = Persistence::UserAccessor.find(user_id)
      expect(persisted_user[:name]).to eq('Frodo Baggins')
    end

    it 'returns validation errors and does not persist a new user' do
      expect(Persistence::UserAccessor).to_not receive(:create)

      status, response = Domain::Users.create({})

      expect(status).to eq(400)
      errors = response[:errors]
      expect(errors.size).to eq(1)
      expect(errors.first).to eq('name required')
    end
  end
end
