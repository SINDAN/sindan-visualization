class AddNetworkTypeToLogCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :log_campaigns, :network_type, :string
  end
end
