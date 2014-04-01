require 'spec_helper'

describe UsersController do
  before do
    @admin = FactoryGirl.create(:admin)
    @users = FactoryGirl.create_list(:user, 3)
  end

  describe "GET 'index'" do
    context "as admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return the correct users" do
        get :index
        expect(assigns(:users)).to eq [@users.reverse, @admin].flatten
      end
    end

    context "as regular user" do
      before { sign_in @users.first }

      it "should be denied" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to root_url
      end
    end
  end
end
