require 'rails_helper'

RSpec.describe "LogCampaigns", type: :request do
  before(:each) do
    @log_campaign = FactoryGirl.create(:log_campaign)
  end

  describe "GET /log_campaigns" do
    it "works!" do
      get log_campaigns_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_campaigns/:id" do
    it "works!" do
      get log_campaign_path(@log_campaign)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_campaigns/new" do
    it "works!" do
      get new_log_campaign_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_campaigns/:id/edit" do
    it "works!" do
      get edit_log_campaign_path(@log_campaign)
      expect(response).to have_http_status(200)
    end
  end
end
