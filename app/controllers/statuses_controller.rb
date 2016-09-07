class StatusesController < ApplicationController
  before_filter :authenticate_user!

  # GET /status
  # GET /status.json
  def index
    @ssid = params[:ssid]
#    @ssid_list = LogCampaign.uniq.pluck(:ssid)

    @time_list = 55.step(0, -5).map { |i| DateTime.now - i.minutes }
    @layers = DiagnosisLog.layer_defs.keys.reverse

    # TODO: get log per ssid
    @target_logs = DiagnosisLog.occurred_after(DateTime.now - 1.hours)

    @diagnosis_logs = @target_logs.fail
  end
end
