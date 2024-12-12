require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #about" do
    it "returns http success" do
      get :about, params: {}
      expect(response).to be_successful
    end
  end
end
