require 'rails_helper'

RSpec.describe LogCampaign, type: :model do
  before(:each) do
    @log_campaign = LogCampaign.new()
  end

  it "is valid with valid attributes" do
    expect(@log_campaign).to be_valid
  end

  it "is not valid with same value of log_unit_uuid" do
    @log_campaign.log_unit_uuid = "8D9CEC4B-9A99-4A44-BFDA-445C6765475A"
    @log_campaign.save

    @log_campaign2 = FactoryGirl.build(:log_campaign)
    @log_campaign2.log_unit_uuid = "8D9CEC4B-9A99-4A44-BFDA-445C6765475A"

    expect(@log_campaign2).not_to be_valid
  end
end
