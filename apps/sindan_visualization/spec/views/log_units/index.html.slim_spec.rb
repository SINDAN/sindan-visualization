require 'rails_helper'

RSpec.describe "log_units/index", type: :view do
  before(:each) do
    assign(:log_units, [
      LogUnit.create!(
        :log_unit_uuid => "Log Unit Uuid 1",
        :mac_addr => "Mac Addr",
        :os => "Os",
        :occurred_at => "2015-07-24 19:24:42",
      ),
      LogUnit.create!(
        :log_unit_uuid => "Log Unit Uuid 2",
        :mac_addr => "Mac Addr",
        :os => "Os",
        :occurred_at => "2015-07-24 19:24:42",
      )
    ])
  end

  it "renders a list of log_units" do
    render
    assert_select "tr>td", :text => "Log Unit Uuid 1".to_s, :count => 1
    assert_select "tr>td", :text => "Log Unit Uuid 2".to_s, :count => 1
    assert_select "tr>td", :text => "Mac Addr".to_s, :count => 2
    assert_select "tr>td", :text => "Os".to_s, :count => 2
  end
end
