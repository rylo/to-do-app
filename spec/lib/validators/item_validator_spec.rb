require 'spec_helper'
require 'validators/item_validator'

RSpec.describe ItemValidator do
  describe '.validate' do
    it 'returns an empty array if all the payload keys exist' do
      attributes = {
        'userName' => 'Nobody',
        'description' => 'the description!',
        'complete' => true,
        'dueDate' => '2015-08-24 22:16:54 -0500'
      }

      errors = described_class.validate(attributes)

      expect(errors).to be_empty
    end

    it 'returns errors if the payload is missing a username' do
      attributes = {
        'description' => 'the description!',
        'complete' => true,
        'dueDate' => '2015-08-24 22:16:54 -0500'
      }

      errors = described_class.validate(attributes)

      expect(errors.size).to eq(1)
      expect(errors.first).to eq('userName required')
    end

    it 'returns errors if the payload is missing a description' do
      attributes = {
        'userName' => 'Nobody',
        'complete' => true,
        'dueDate' => '2015-08-24 22:16:54 -0500'
      }

      errors = described_class.validate(attributes)

      expect(errors.size).to eq(1)
      expect(errors.first).to eq('description required')
    end

    it 'returns errors if the payload is missing completion data' do
      attributes = {
        'userName' => 'Nobody',
        'description' => 'the description!',
        'dueDate' => '2015-08-24 22:16:54 -0500'
      }

      errors = described_class.validate(attributes)

      expect(errors.size).to eq(1)
      expect(errors.first).to eq('complete required')
    end

    it 'returns errors if the payload is missing a due date' do
      attributes = {
        'userName' => 'Nobody',
        'description' => 'the description!',
        'complete' => true,
      }

      errors = described_class.validate(attributes)

      expect(errors.size).to eq(1)
      expect(errors.first).to eq('dueDate required')
    end

    it 'returns multiple errors if the payload is missing multiple required fields' do
      attributes = {}

      errors = described_class.validate(attributes)

      expect(errors.size).to eq(4)
    end
  end
end
