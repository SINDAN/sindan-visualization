class LogCampaign < ApplicationRecord
  has_many :diagnosis_logs, foreign_key: :log_campaign_uuid, primary_key: :log_campaign_uuid

  default_scope { order(occurred_at: :desc) }

  validates_uniqueness_of :log_campaign_uuid,
                          if: Proc.new { |record| !record.log_campaign_uuid.blank? }

  def result
    if self.diagnosis_logs.fail.count > 0
      ignore_log_types = IgnoreErrorResult.where(ssid: self.ssid).first.try(:ignore_log_types)

      if self.diagnosis_logs.fail.where.not(log_type: ignore_log_types).count > 0
        'fail'
      else
        'warning'
      end

    elsif self.diagnosis_logs.success.count > 0
      'success'
    else
      'information'
    end
  end
end
