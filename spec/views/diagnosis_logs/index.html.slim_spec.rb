require 'rails_helper'

RSpec.describe "diagnosis_logs/index", type: :view do
  before(:each) do
    assign(:diagnosis_logs, [
      DiagnosisLog.create!(
        :case_name => "Case Name",
        :node_name => "MyText",
        :ssid => "Ssid"
      ),
      DiagnosisLog.create!(
        :case_name => "Case Name",
        :node_name => "MyText",
        :ssid => "Ssid"
      )
    ])
  end

  it "renders a list of diagnosis_logs" do
    render
    assert_select "tr>td", :text => "Case Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Ssid".to_s, :count => 2
  end
end
