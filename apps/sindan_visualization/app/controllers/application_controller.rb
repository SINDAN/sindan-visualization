class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_diagnosis_log_dates

  def set_diagnosis_log_dates
    @diagnosis_log_dates = DiagnosisLog.all.map{ |d| d.occurred_at.to_date.to_s unless d.occurred_at.blank? }.uniq
  end
end