json.array!(@diagnosis_logs) do |diagnosis_log|
  json.extract! diagnosis_log, :id, :case_name, :node_name, :ssid
  json.url diagnosis_log_url(diagnosis_log, format: :json)
end
