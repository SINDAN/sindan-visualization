class AddVersionToLogCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :log_campaigns, :version, :string
  end
end
