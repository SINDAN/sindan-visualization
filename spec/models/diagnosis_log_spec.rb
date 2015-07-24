require 'rails_helper'

RSpec.describe DiagnosisLog, type: :model do
  before(:each) do
    @diagnosis_log = DiagnosisLog.new()
  end

  it "is valid with valid attributes" do
    expect(@diagnosis_log).to be_valid
  end
end
