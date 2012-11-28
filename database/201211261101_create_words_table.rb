Sequel.migration do
  up do
    create_table :words do
      primary_key :submission_id
      column :language,        String,   null: false
      column :words,           "TEXT",   null: false
      column :submission_time, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :submission_ip,   String,   null: false
    end
  end
end
