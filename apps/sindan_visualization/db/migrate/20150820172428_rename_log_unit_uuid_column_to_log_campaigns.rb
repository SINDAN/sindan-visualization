class RenameLogUnitUuidColumnToLogCampaigns < ActiveRecord::Migration
  def change
    rename_column :log_campaigns, :log_unit_uuid, :log_campaign_uuid
  end
end
