Sequel.migration do
  up do
    rename_table :words, :submissions
    alter_table :submissions do
      rename_column :words, :feeling
    end
  end
end
