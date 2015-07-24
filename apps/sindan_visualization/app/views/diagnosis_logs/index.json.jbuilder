json.array!(@diagnosis_logs) do |diagnosis_log|
  json.extract! diagnosis_log, :id, :layer, :log_type, :result, :detail, :occurred_at
  json.url diagnosis_log_url(diagnosis_log, format: :json)
end
