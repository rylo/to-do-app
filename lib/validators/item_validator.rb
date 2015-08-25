class ItemValidator
  class << self
    REQUIRED_KEYS = %w(userName description complete dueDate).freeze

    def validate(item_attributes)
      [].tap do |errors|
        REQUIRED_KEYS.each do |required_key|
          errors << "#{required_key} required" if item_attributes[required_key].nil?
        end
      end
    end

  end
end
