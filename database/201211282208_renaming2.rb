Sequel.migration do
  up do
    alter_table :banished_tags do
      rename_column :word, :tag
    end
  end
end
