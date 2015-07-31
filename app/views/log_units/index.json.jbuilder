json.array!(@log_units) do |log_unit|
  json.extract! log_unit, :id, :log_unit_uuid, :mac_addr, :os, :occurred_at
  json.url log_unit_url(log_unit, format: :json)
end
