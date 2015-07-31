class DiagnosisLog < ActiveRecord::Base
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
