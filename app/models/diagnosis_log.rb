class DiagnosisLog < ActiveRecord::Base
  belongs_to :log_unit, foreign_key: :log_unit_uuid, primary_key: :log_unit_uuid

  enum result: {
         fail: 0,
         success: 1,
         information: 10,
       }

  def result_label
    unless self.result.nil?
      self.result
    end
  end
end
