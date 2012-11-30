Sequel.migration do
  up do
    run <<-SQL
      update submissions set language=lower(language)
    SQL
  end
end
