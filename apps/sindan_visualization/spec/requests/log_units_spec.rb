require 'rails_helper'

RSpec.describe "LogUnits", type: :request do
  before(:each) do
    @log_unit = FactoryGirl.create(:log_unit)
  end

  describe "GET /log_units" do
    it "works!" do
      get log_units_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_units/:id" do
    it "works!" do
      get log_unit_path(@log_unit)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_units/new" do
    it "works!" do
      get new_log_unit_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /log_units/:id/edit" do
    it "works!" do
      get edit_log_unit_path(@log_unit)
      expect(response).to have_http_status(200)
    end
  end
end
