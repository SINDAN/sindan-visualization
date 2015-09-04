class AddIndexToLogCampaign < ActiveRecord::Migration
  def change
    add_index :log_campaigns, :occurred_at
  end
end
