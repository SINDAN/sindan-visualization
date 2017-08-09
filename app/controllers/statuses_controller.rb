class StatusesController < ApplicationController
  before_action :authenticate_user!

  # GET /status
  # GET /status.json
  def index
    @ssid = params[:ssid]
#    @ssid_list = LogCampaign.uniq.pluck(:ssid)

    term = 10
    count = 12
    time = Time.zone.now
    @time_list = ((count - 1) * term).step(0, -1 * term).map { |i| time - i.minutes }
    @layers = DiagnosisLog.layer_defs.keys.reverse

    # TODO: get log per ssid
    @target_logs = DiagnosisLog.occurred_after(time - (term * count).minutes)

    @diagnosis_logs = @target_logs.fail
  end
end
