require 'spec_helper'

describe DatapathsController do
  before { @admin = FactoryGirl.create(:admin) }

  describe "GET 'index'" do
    before { @datapaths = FactoryGirl.create_list(:test_datapath, 3) }

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return all datapaths" do
        get :index
        expect(assigns(:datapaths)).to eq @datapaths
      end
    end

    context "as regular user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
