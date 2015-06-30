require 'rails_helper'

RSpec.describe "diagnosis_logs/new", type: :view do
  before(:each) do
    assign(:diagnosis_log, DiagnosisLog.new(
      :case_name => "MyString",
      :node_name => "MyText",
      :ssid => "MyString"
    ))
  end

  it "renders new diagnosis_log form" do
    render

    assert_select "form[action=?][method=?]", diagnosis_logs_path, "post" do

      assert_select "input#diagnosis_log_case_name[name=?]", "diagnosis_log[case_name]"

      assert_select "textarea#diagnosis_log_node_name[name=?]", "diagnosis_log[node_name]"

      assert_select "input#diagnosis_log_ssid[name=?]", "diagnosis_log[ssid]"
    end
  end
end
