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

RSpec.describe LogUnitsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # LogUnit. As you add validations to LogUnit, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LogUnitsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all log_units as @log_units" do
      log_unit = LogUnit.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:log_units)).to eq([log_unit])
    end
  end

  describe "GET #show" do
    it "assigns the requested log_unit as @log_unit" do
      log_unit = LogUnit.create! valid_attributes
      get :show, {:id => log_unit.to_param}, valid_session
      expect(assigns(:log_unit)).to eq(log_unit)
    end
  end

  describe "GET #new" do
    it "assigns a new log_unit as @log_unit" do
      get :new, {}, valid_session
      expect(assigns(:log_unit)).to be_a_new(LogUnit)
    end
  end

  describe "GET #edit" do
    it "assigns the requested log_unit as @log_unit" do
      log_unit = LogUnit.create! valid_attributes
      get :edit, {:id => log_unit.to_param}, valid_session
      expect(assigns(:log_unit)).to eq(log_unit)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new LogUnit" do
        expect {
          post :create, {:log_unit => valid_attributes}, valid_session
        }.to change(LogUnit, :count).by(1)
      end

      it "assigns a newly created log_unit as @log_unit" do
        post :create, {:log_unit => valid_attributes}, valid_session
        expect(assigns(:log_unit)).to be_a(LogUnit)
        expect(assigns(:log_unit)).to be_persisted
      end

      it "redirects to the created log_unit" do
        post :create, {:log_unit => valid_attributes}, valid_session
        expect(response).to redirect_to(LogUnit.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved log_unit as @log_unit" do
        post :create, {:log_unit => invalid_attributes}, valid_session
        expect(assigns(:log_unit)).to be_a_new(LogUnit)
      end

      it "re-renders the 'new' template" do
        post :create, {:log_unit => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested log_unit" do
        log_unit = LogUnit.create! valid_attributes
        put :update, {:id => log_unit.to_param, :log_unit => new_attributes}, valid_session
        log_unit.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested log_unit as @log_unit" do
        log_unit = LogUnit.create! valid_attributes
        put :update, {:id => log_unit.to_param, :log_unit => valid_attributes}, valid_session
        expect(assigns(:log_unit)).to eq(log_unit)
      end

      it "redirects to the log_unit" do
        log_unit = LogUnit.create! valid_attributes
        put :update, {:id => log_unit.to_param, :log_unit => valid_attributes}, valid_session
        expect(response).to redirect_to(log_unit)
      end
    end

    context "with invalid params" do
      it "assigns the log_unit as @log_unit" do
        log_unit = LogUnit.create! valid_attributes
        put :update, {:id => log_unit.to_param, :log_unit => invalid_attributes}, valid_session
        expect(assigns(:log_unit)).to eq(log_unit)
      end

      it "re-renders the 'edit' template" do
        log_unit = LogUnit.create! valid_attributes
        put :update, {:id => log_unit.to_param, :log_unit => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested log_unit" do
      log_unit = LogUnit.create! valid_attributes
      expect {
        delete :destroy, {:id => log_unit.to_param}, valid_session
      }.to change(LogUnit, :count).by(-1)
    end

    it "redirects to the log_units list" do
      log_unit = LogUnit.create! valid_attributes
      delete :destroy, {:id => log_unit.to_param}, valid_session
      expect(response).to redirect_to(log_units_url)
    end
  end

end
