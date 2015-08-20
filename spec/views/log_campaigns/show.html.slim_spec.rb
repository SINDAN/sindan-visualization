require 'rails_helper'

RSpec.describe "log_campaigns/show", type: :view do
  before(:each) do
    @log_campaign = assign(:log_campaign, LogCampaign.create!(
      :log_unit_uuid => "Log Unit Uuid",
      :mac_addr => "Mac Addr",
      :os => "Os",
      :occurred_at => "2015-07-24 19:24:42",
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Log Unit Uuid/)
    expect(rendered).to match(/Mac Addr/)
    expect(rendered).to match(/Os/)
  end
end
