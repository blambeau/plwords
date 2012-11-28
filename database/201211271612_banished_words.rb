Sequel.migration do
  up do
    create_table :banished do
      column :word, String,   null: false
      primary_key :word
    end
  end
end
