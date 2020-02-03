if ActiveRecord::Base.connection.table_exists? 'lookup_tables'
  lookup_tables = JSON.parse(LookupTable.all.to_json)
  Object.const_set('LOOKUP_TABLE', lookup_tables)
end