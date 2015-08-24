require 'spec_helper'
require 'presenters/user_presenter'

RSpec.describe Presenters::UserPresenter do
  describe '.present' do
    it 'presents an item as a hash' do
      user = {
        id: 1234,
        name: 'Arya Stark'
      }

      presented_user = Presenters::UserPresenter.present(user)

      expect(presented_user[:id]).to eq(1234)
      expect(presented_user[:name]).to eq('Arya Stark')
    end
  end
end
