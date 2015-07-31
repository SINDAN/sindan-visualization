require 'rails_helper'

RSpec.describe LogUnit, type: :model do
  before(:each) do
    @log_unit = LogUnit.new()
  end

  it "is valid with valid attributes" do
    expect(@log_unit).to be_valid
  end

  it "is not valid with same value of log_unit_uuid" do
    @log_unit.log_unit_uuid = "8D9CEC4B-9A99-4A44-BFDA-445C6765475A"
    @log_unit.save

    @log_unit2 = FactoryGirl.build(:log_unit)
    @log_unit2.log_unit_uuid = "8D9CEC4B-9A99-4A44-BFDA-445C6765475A"

    expect(@log_unit2).not_to be_valid
  end
end
