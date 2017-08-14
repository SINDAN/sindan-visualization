require 'rails_helper'

RSpec.describe IgnoreErrorResult, type: :model do
  before(:each) do
    @ignore_error_result = IgnoreErrorResult.new(
      ssid: 'SSID'
    )
  end

  it "is valid with valid attributes" do
    expect(@ignore_error_result).to be_valid
  end

  it "is not valid without ssid" do
    @ignore_error_result.ssid = nil

    expect(@ignore_error_result).not_to be_valid
  end
end
