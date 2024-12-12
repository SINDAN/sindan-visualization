class LogCampaign < ApplicationRecord
  has_many :diagnosis_logs, foreign_key: :log_campaign_uuid, primary_key: :log_campaign_uuid

  default_scope { order(occurred_at: :desc) }

  scope :occurred_before, ->(time) { where(arel_table[:occurred_at].lt(time)) }
  scope :occurred_after, ->(time) { where(arel_table[:occurred_at].gt(time)) }

  validates_uniqueness_of :log_campaign_uuid, case_sensitive: true,
                          if: Proc.new { |record| !record.log_campaign_uuid.blank? }

  def result
    ignore_log_types = IgnoreErrorResult.ignore_log_types_by_ssid(self.ssid)

    if self.diagnosis_logs.fail.where(log_type: ignore_log_types).count > 0
      return "warning"
    end

    if self.diagnosis_logs.fail.count > 0
      return "fail"
    end

    if self.diagnosis_logs.success.count > 0
      return "success"
    end

    "information"
  end

  def result_label
    ignore_log_types = IgnoreErrorResult.ignore_log_types_by_ssid(self.ssid)

    if self.diagnosis_logs.fail.where(log_type: ignore_log_types).count > 0
      return "table-warning"
    end

    if self.diagnosis_logs.fail.count > 0
      return "table-danger"
    end

    if self.diagnosis_logs.success.count > 0
      return "table-success"
    end

    ""
  end

  def self.ssid_list
    Rails.cache.fetch("ssid_list", expires_in: 1.hours) do
      LogCampaign.pluck(:ssid).uniq.compact
    end
  end
end
