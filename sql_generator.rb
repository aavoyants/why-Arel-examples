def build_query(code, lat, lon)
  m = build_insert_manager
  m.insert [
    [table[:code], code],
    [table[:lat],  lat],
    [table[:lon],  lon]
  ]
  m.to_sql
end

def build_insert_manager
  Arel::InsertManager.new Arel::Table.engine
end

def table
  @table ||= Postcode.arel_table
end
