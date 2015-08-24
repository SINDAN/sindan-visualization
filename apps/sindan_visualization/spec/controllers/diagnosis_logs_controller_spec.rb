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

RSpec.describe DiagnosisLogsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DiagnosisLog. As you add validations to DiagnosisLog, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { detail: "detail" }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DiagnosisLogsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all diagnosis_logs as @diagnosis_logs" do
      diagnosis_log = DiagnosisLog.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:diagnosis_logs)).to eq([diagnosis_log])
    end

    context "with date param" do
      it "assigns all diagnosis_logs as @diagnosis_logs" do
        diagnosis_log = DiagnosisLog.create!(occurred_at: '2015-07-31 19:24:42')
        get :index, { date: '20150731' }, valid_session
        expect(assigns(:diagnosis_logs)).to eq([diagnosis_log])
      end

      it "assigns no diagnosis_logs as @diagnosis_logs" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        get :index, { date: '20150731' }, valid_session
        expect(assigns(:diagnosis_logs)).to eq([])
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested diagnosis_log as @diagnosis_log" do
      diagnosis_log = DiagnosisLog.create! valid_attributes
      get :show, {:id => diagnosis_log.to_param}, valid_session
      expect(assigns(:diagnosis_log)).to eq(diagnosis_log)
    end
  end

  describe "GET #new" do
    it "assigns a new diagnosis_log as @diagnosis_log" do
      get :new, {}, valid_session
      expect(assigns(:diagnosis_log)).to be_a_new(DiagnosisLog)
    end
  end

  describe "GET #edit" do
    it "assigns the requested diagnosis_log as @diagnosis_log" do
      diagnosis_log = DiagnosisLog.create! valid_attributes
      get :edit, {:id => diagnosis_log.to_param}, valid_session
      expect(assigns(:diagnosis_log)).to eq(diagnosis_log)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DiagnosisLog" do
        expect {
          post :create, {:diagnosis_log => valid_attributes}, valid_session
        }.to change(DiagnosisLog, :count).by(1)
      end

      it "assigns a newly created diagnosis_log as @diagnosis_log" do
        post :create, {:diagnosis_log => valid_attributes}, valid_session
        expect(assigns(:diagnosis_log)).to be_a(DiagnosisLog)
        expect(assigns(:diagnosis_log)).to be_persisted
      end

      it "redirects to the created diagnosis_log" do
        post :create, {:diagnosis_log => valid_attributes}, valid_session
        expect(response).to redirect_to(DiagnosisLog.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved diagnosis_log as @diagnosis_log" do
        post :create, {:diagnosis_log => invalid_attributes}, valid_session
        expect(assigns(:diagnosis_log)).to be_a_new(DiagnosisLog)
      end

      it "re-renders the 'new' template" do
        post :create, {:diagnosis_log => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { detail: "new detail" }
      }

      it "updates the requested diagnosis_log" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        put :update, {:id => diagnosis_log.to_param, :diagnosis_log => new_attributes}, valid_session
        diagnosis_log.reload
        expect(diagnosis_log.detail).to eq new_attributes[:detail]
      end

      it "assigns the requested diagnosis_log as @diagnosis_log" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        put :update, {:id => diagnosis_log.to_param, :diagnosis_log => valid_attributes}, valid_session
        expect(assigns(:diagnosis_log)).to eq(diagnosis_log)
      end

      it "redirects to the diagnosis_log" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        put :update, {:id => diagnosis_log.to_param, :diagnosis_log => valid_attributes}, valid_session
        expect(response).to redirect_to(diagnosis_log)
      end
    end

    context "with invalid params" do
      it "assigns the diagnosis_log as @diagnosis_log" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        put :update, {:id => diagnosis_log.to_param, :diagnosis_log => invalid_attributes}, valid_session
        expect(assigns(:diagnosis_log)).to eq(diagnosis_log)
      end

      it "re-renders the 'edit' template" do
        diagnosis_log = DiagnosisLog.create! valid_attributes
        put :update, {:id => diagnosis_log.to_param, :diagnosis_log => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested diagnosis_log" do
      diagnosis_log = DiagnosisLog.create! valid_attributes
      expect {
        delete :destroy, {:id => diagnosis_log.to_param}, valid_session
      }.to change(DiagnosisLog, :count).by(-1)
    end

    it "redirects to the diagnosis_logs list" do
      diagnosis_log = DiagnosisLog.create! valid_attributes
      delete :destroy, {:id => diagnosis_log.to_param}, valid_session
      expect(response).to redirect_to(diagnosis_logs_url)
    end
  end

end
