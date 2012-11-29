Sequel.migration do
  up do
    create_table :banished_words do
      column :word, String, null: false
      primary_key :word
    end
    create_table :translations do
      column :word, String, null: false
      column :tag,  String, null: false
      primary_key :word
    end
  end
end
