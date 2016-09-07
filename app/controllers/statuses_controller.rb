class StatusesController < ApplicationController
  before_filter :authenticate_user!

  # GET /status
  # GET /status.json
  def index
    @ssid = params[:ssid]

#    @ssid_list = LogCampaign.uniq.pluck(:ssid)

    # TODO: get log per ssid
    @diagnosis_logs = DiagnosisLog.fail.limit(10)
  end
end
