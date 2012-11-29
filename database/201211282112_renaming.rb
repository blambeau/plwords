Sequel.migration do
  up do
    rename_table :words, :submissions
    alter_table :submissions do
      rename_column :words, :tags
    end
    rename_table :banished, :banished_tags
  end
end
