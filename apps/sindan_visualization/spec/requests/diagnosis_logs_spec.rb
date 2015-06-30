require 'rails_helper'

RSpec.describe "DiagnosisLogs", type: :request do
  describe "GET /diagnosis_logs" do
    it "works! (now write some real specs)" do
      get diagnosis_logs_path
      expect(response).to have_http_status(200)
    end
  end
end
