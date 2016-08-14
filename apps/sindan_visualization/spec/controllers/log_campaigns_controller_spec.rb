require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe LogCampaignsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # LogCampaign. As you add validations to LogCampaign, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { mac_addr: "mac_addr" }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LogCampaignsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "for authenticated users" do
    login_user

    describe "GET #index" do
      it "assigns all log_campaigns as @log_campaigns" do
        log_campaign = LogCampaign.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(assigns(:log_campaigns)).to eq([log_campaign])
      end
    end

    describe "GET #show" do
      it "assigns the requested log_campaign as @log_campaign" do
        log_campaign = LogCampaign.create! valid_attributes
        get :show, params: { id: log_campaign.to_param }, session: valid_session
        expect(assigns(:log_campaign)).to eq(log_campaign)
      end
    end

    describe "GET #all" do
      before(:each) do
        @log_campaign = FactoryGirl.create(:log_campaign)
        @diagnosis_log = FactoryGirl.create(:diagnosis_log, log_campaign: @log_campaign, result: 'success')
      end

      it "assigns the requested log_campaign as @log_campaign" do
        get :all, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:log_campaign)).to eq(@log_campaign)
      end

      it "assigns the requested diagnosis_logs as @diagnosis_logs" do
        get :all, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:diagnosis_logs)).to eq([@diagnosis_log])
      end
    end

    describe "GET #log" do
      before(:each) do
        @log_campaign = FactoryGirl.create(:log_campaign)
        @diagnosis_log = FactoryGirl.create(:diagnosis_log, log_campaign: @log_campaign, result: 'success')
      end

      it "assigns the requested log_campaign as @log_campaign" do
        get :log, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:log_campaign)).to eq(@log_campaign)
      end

      it "assigns the requested diagnosis_logs as @diagnosis_logs" do
        get :log, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:diagnosis_logs)).to eq([@diagnosis_log])
      end
    end

    describe "GET #error" do
      before(:each) do
        @log_campaign = FactoryGirl.create(:log_campaign)
        @diagnosis_log = FactoryGirl.create(:diagnosis_log, log_campaign: @log_campaign, result: 'fail')
      end

      it "assigns the requested log_campaign as @log_campaign" do
        get :error, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:log_campaign)).to eq(@log_campaign)
      end

      it "assigns the requested diagnosis_logs as @diagnosis_logs" do
        get :error, params: { id: @log_campaign.to_param }, session: valid_session
        expect(assigns(:diagnosis_logs)).to eq([@diagnosis_log])
      end
    end

    describe "GET #new" do
      it "assigns a new log_campaign as @log_campaign" do
        get :new, params: {}, session: valid_session
        expect(assigns(:log_campaign)).to be_a_new(LogCampaign)
      end
    end

    describe "GET #edit" do
      it "assigns the requested log_campaign as @log_campaign" do
        log_campaign = LogCampaign.create! valid_attributes
        get :edit, params: { id: log_campaign.to_param }, session: valid_session
        expect(assigns(:log_campaign)).to eq(log_campaign)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new LogCampaign" do
          expect {
            post :create, params: { log_campaign: valid_attributes }, session: valid_session
          }.to change(LogCampaign, :count).by(1)
        end

        it "assigns a newly created log_campaign as @log_campaign" do
          post :create, params: { log_campaign: valid_attributes }, session: valid_session
          expect(assigns(:log_campaign)).to be_a(LogCampaign)
          expect(assigns(:log_campaign)).to be_persisted
        end

        it "redirects to the created log_campaign" do
          post :create, params: { log_campaign: valid_attributes }, session: valid_session
          expect(response).to redirect_to(LogCampaign.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved log_campaign as @log_campaign" do
          post :create, params: { log_campaign: invalid_attributes }, session: valid_session
          expect(assigns(:log_campaign)).to be_a_new(LogCampaign)
        end

        it "re-renders the 'new' template" do
          post :create, params: { log_campaign: invalid_attributes }, session: valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { mac_addr: "mac_addr2" }
        }

        it "updates the requested log_campaign" do
          log_campaign = LogCampaign.create! valid_attributes
          put :update, params: { id: log_campaign.to_param, log_campaign: new_attributes }, session: valid_session
          log_campaign.reload
          expect(log_campaign.mac_addr).to eq new_attributes[:mac_addr]
        end

        it "assigns the requested log_campaign as @log_campaign" do
          log_campaign = LogCampaign.create! valid_attributes
          put :update, params: { id: log_campaign.to_param, log_campaign: valid_attributes }, session: valid_session
          expect(assigns(:log_campaign)).to eq(log_campaign)
        end

        it "redirects to the log_campaign" do
          log_campaign = LogCampaign.create! valid_attributes
          put :update, params: { id: log_campaign.to_param, log_campaign: valid_attributes }, session: valid_session
          expect(response).to redirect_to(log_campaign)
        end
      end

      context "with invalid params" do
        it "assigns the log_campaign as @log_campaign" do
          log_campaign = LogCampaign.create! valid_attributes
          put :update, params: { id: log_campaign.to_param, log_campaign: invalid_attributes }, session: valid_session
          expect(assigns(:log_campaign)).to eq(log_campaign)
        end

        it "re-renders the 'edit' template" do
          log_campaign = LogCampaign.create! valid_attributes
          put :update, params: { id: log_campaign.to_param, log_campaign: invalid_attributes }, session: valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested log_campaign" do
        log_campaign = LogCampaign.create! valid_attributes
        expect {
          delete :destroy, params: { id: log_campaign.to_param }, session: valid_session
        }.to change(LogCampaign, :count).by(-1)
      end

      it "redirects to the log_campaigns list" do
        log_campaign = LogCampaign.create! valid_attributes
        delete :destroy, params: { id: log_campaign.to_param }, session: valid_session
        expect(response).to redirect_to(log_campaigns_url)
      end
    end
  end
end
