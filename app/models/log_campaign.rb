class LogCampaign < ActiveRecord::Base
  has_many :diagnosis_logs, foreign_key: :log_unit_uuid, primary_key: :log_unit_uuid

  validates_uniqueness_of :log_unit_uuid,
                          if: Proc.new { |record| !record.log_unit_uuid.blank? }
end
