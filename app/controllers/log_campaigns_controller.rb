class LogCampaignsController < ApplicationController
  before_action :set_log_campaign, only: [:show, :all, :log, :error, :edit, :update, :destroy]

  # GET /log_campaigns
  # GET /log_campaigns.json
  def index
    @log_campaigns = LogCampaign.all
  end

  # GET /log_campaigns/1
  # GET /log_campaigns/1.json
  def show
    @diagnosis_logs = @log_campaign.diagnosis_logs.log
  end

  # GET /log_campaigns/1/all
  # GET /log_campaigns/1/all.json
  def all
    @diagnosis_logs = @log_campaign.diagnosis_logs

    render action: :show
  end

  # GET /log_campaigns/1/log
  # GET /log_campaigns/1/log.json
  def log
    @diagnosis_logs = @log_campaign.diagnosis_logs.log

    render action: :show
  end

  # GET /log_campaigns/1/error
  # GET /log_campaigns/1/error.json
  def error
    @diagnosis_logs = @log_campaign.diagnosis_logs.fail

    render action: :show
  end

  # GET /log_campaigns/new
  def new
    @log_campaign = LogCampaign.new
  end

  # GET /log_campaigns/1/edit
  def edit
  end

  # POST /log_campaigns
  # POST /log_campaigns.json
  def create
    @log_campaign = LogCampaign.new(log_campaign_params)

    respond_to do |format|
      if @log_campaign.save
        format.html { redirect_to @log_campaign, notice: 'Log campaign was successfully created.' }
        format.json { render :show, status: :created, location: @log_campaign }
      else
        format.html { render :new }
        format.json { render json: @log_campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_campaigns/1
  # PATCH/PUT /log_campaigns/1.json
  def update
    respond_to do |format|
      if @log_campaign.update(log_campaign_params)
        format.html { redirect_to @log_campaign, notice: 'Log campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @log_campaign }
      else
        format.html { render :edit }
        format.json { render json: @log_campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_campaigns/1
  # DELETE /log_campaigns/1.json
  def destroy
    @log_campaign.destroy
    respond_to do |format|
      format.html { redirect_to log_campaigns_url, notice: 'Log campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log_campaign
      @log_campaign = LogCampaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_campaign_params
      params.require(:log_campaign).permit(:log_campaign_uuid, :mac_addr, :os, :occurred_at)
    end
end
