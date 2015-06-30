require 'rails_helper'

RSpec.describe "diagnosis_logs/edit", type: :view do
  before(:each) do
    @diagnosis_log = assign(:diagnosis_log, DiagnosisLog.create!(
      :case_name => "MyString",
      :node_name => "MyText",
      :ssid => "MyString"
    ))
  end

  it "renders the edit diagnosis_log form" do
    render

    assert_select "form[action=?][method=?]", diagnosis_log_path(@diagnosis_log), "post" do

      assert_select "input#diagnosis_log_case_name[name=?]", "diagnosis_log[case_name]"

      assert_select "textarea#diagnosis_log_node_name[name=?]", "diagnosis_log[node_name]"

      assert_select "input#diagnosis_log_ssid[name=?]", "diagnosis_log[ssid]"
    end
  end
end
