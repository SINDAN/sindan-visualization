require 'rails_helper'

RSpec.describe "log_units/new", type: :view do
  before(:each) do
    assign(:log_unit, LogUnit.new(
      :log_unit_uuid => "MyString",
      :mac_addr => "MyString",
      :os => "MyString",
      :occurred_at => "2015-07-24 19:24:42",
    ))
  end

  it "renders new log_unit form" do
    render

    assert_select "form[action=?][method=?]", log_units_path, "post" do

      assert_select "input#log_unit_log_unit_uuid[name=?]", "log_unit[log_unit_uuid]"

      assert_select "input#log_unit_mac_addr[name=?]", "log_unit[mac_addr]"

      assert_select "input#log_unit_os[name=?]", "log_unit[os]"

      assert_select "select#log_unit_occurred_at_1i[name=?]", "log_unit[occurred_at(1i)]"
    end
  end
end
