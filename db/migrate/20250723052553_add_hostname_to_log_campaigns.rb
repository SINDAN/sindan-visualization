class AddHostnameToLogCampaigns < ActiveRecord::Migration[8.0]
  def change
    add_column :log_campaigns, :hostname, :string

    add_index :log_campaigns, :hostname
  end
end
