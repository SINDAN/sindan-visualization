require 'rails_helper'

RSpec.describe "log_campaigns/show", type: :view do
  before(:each) do
    @log_campaign = assign(:log_campaign, LogCampaign.create!(
      log_campaign_uuid: "Log Campaign Uuid",
      ssid: "SSID",
      network_type: "NetworkType",
      hostname: "HostName",
      mac_addr: "Mac Addr",
      os: "Os",
      version: "Version",
      occurred_at: "2015-07-24 19:24:42",
    ))

    assign(:diagnosis_logs, [
      DiagnosisLog.create!(
        layer: "Layer",
        log_group: "Log Group",
        log_type: "Log Type",
        target: "Target",
        result: :success,
        detail: "Detail",
        occurred_at: "2015-07-24 19:24:42",
      ),
      DiagnosisLog.create!(
        layer: "Layer",
        log_group: "Log Group",
        log_type: "Log Type",
        target: "Target",
        result: :fail,
        detail: "Detail",
        occurred_at: "2015-07-24 19:24:42",
      )
    ])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Log Campaign Uuid/)
    expect(rendered).to match(/SSID/)
    expect(rendered).to match(/NetworkType/)
    expect(rendered).to match(/HostName/)
    expect(rendered).to match(/Mac Addr/)
    expect(rendered).to match(/Os/)
    expect(rendered).to match(/Version/)
  end

  it "renders related attributes in <p>" do
    render

    assert_select "table#diagnosis_logs" do
      assert_select "tr>td", text: "Layer".to_s, count: 2
      assert_select "tr>td", text: "Log Group".to_s, count: 2
      assert_select "tr>td", text: "Log Type".to_s, count: 2
      assert_select "tr>td", text: "Target".to_s, count: 2
    end
  end
end
