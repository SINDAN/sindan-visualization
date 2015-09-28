class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_diagnosis_log_dates

  def set_diagnosis_log_dates
    @diagnosis_log_dates = DiagnosisLog.date_list
  end

  # for divise
  def after_sign_in_path_for(resource)
    stored_location_for(:user) || root_path
  end
end
