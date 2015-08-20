class RenameLogUnitsToLogCampaigns < ActiveRecord::Migration
  def change
    rename_table :log_units, :log_campaigns
  end
end
