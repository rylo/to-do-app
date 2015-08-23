Sequel.migration do
  up do
    create_table :items do
      primary_key :id
      String :user_name
      Text :description
      DateTime :due_date
      Boolean :complete
    end
  end

  down do
    drop_table :items
  end
end
