json.array!(@log_campaigns) do |log_campaign|
  json.extract! log_campaign, :id, :log_campaign_uuid, :ssid, :network_type, :hostname, :mac_addr, :os, :version, :occurred_at
  json.url log_campaign_url(log_campaign, format: :json)
end
