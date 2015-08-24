require 'rails_helper'

RSpec.describe "DiagnosisLogs", type: :request do
  before(:each) do
    @diagnosis_log = FactoryGirl.create(:diagnosis_log)
  end

  describe "GET /diagnosis_logs" do
    it "works!" do
      get diagnosis_logs_path
      expect(response).to have_http_status(200)
    end

    it "works! with date params" do
      get diagnosis_logs_path(date: '20150731')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /diagnosis_logs/:id" do
    it "works!" do
      get diagnosis_log_path(@diagnosis_log)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /diagnosis_logs/new" do
    it "works!" do
      get new_diagnosis_log_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /diagnosis_logs/:id/edit" do
    it "works!" do
      get edit_diagnosis_log_path(@diagnosis_log)
      expect(response).to have_http_status(200)
    end
  end
end
