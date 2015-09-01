class LogCampaign < ActiveRecord::Base
  has_many :diagnosis_logs, foreign_key: :log_campaign_uuid, primary_key: :log_campaign_uuid

  default_scope { order(occurred_at: :desc) }

  validates_uniqueness_of :log_campaign_uuid,
                          if: Proc.new { |record| !record.log_campaign_uuid.blank? }
end
