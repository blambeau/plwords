Sequel.migration do
  up do
    alter_table :submissions do
      add_index [ :language ], unique: false
    end
    alter_table :translations do
      add_index [ :tag ], unique: false
    end
  end
end