lookup_tables = JSON.parse(LookupTable.all.to_json)
Object.const_set('LOOKUP_TABLE', lookup_tables)