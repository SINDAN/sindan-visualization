require 'rails_helper'

RSpec.describe "diagnosis_logs/index", type: :view do
  before(:each) do
    assign(:diagnosis_logs, [
      DiagnosisLog.create!(
        :layer => "Layer",
        :log_type => "Log Type",
        :result => true,
        :detail => "Detail",
        :occurred_at => "2015-07-24 19:24:42",
      ),
      DiagnosisLog.create!(
        :layer => "Layer",
        :log_type => "Log Type",
        :result => false,
        :detail => "Detail",
        :occurred_at => "2015-07-24 19:24:42",
      )
    ])
  end

  it "renders a list of diagnosis_logs" do
    render
    assert_select "tr>td", :text => "Layer".to_s, :count => 2
    assert_select "tr>td", :text => "Log Type".to_s, :count => 2
  end

  it "renders a class of diagnosis_log result" do
    render
    assert_select "tr.success", :count => 1
    assert_select "tr.danger", :count => 1
  end
end
