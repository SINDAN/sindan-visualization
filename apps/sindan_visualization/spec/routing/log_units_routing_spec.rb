require "rails_helper"

RSpec.describe LogUnitsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/log_units").to route_to("log_units#index")
    end

    it "routes to #new" do
      expect(:get => "/log_units/new").to route_to("log_units#new")
    end

    it "routes to #show" do
      expect(:get => "/log_units/1").to route_to("log_units#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/log_units/1/edit").to route_to("log_units#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/log_units").to route_to("log_units#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/log_units/1").to route_to("log_units#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/log_units/1").to route_to("log_units#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/log_units/1").to route_to("log_units#destroy", :id => "1")
    end

  end
end
