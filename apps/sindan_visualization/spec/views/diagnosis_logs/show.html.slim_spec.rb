require 'rails_helper'

RSpec.describe "diagnosis_logs/show", type: :view do
  before(:each) do
    @diagnosis_log = assign(:diagnosis_log, DiagnosisLog.create!(
      :case_name => "Case Name",
      :node_name => "MyText",
      :ssid => "Ssid"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Case Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Ssid/)
  end
end
