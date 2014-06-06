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
        expect(response).to redirect_to tracks_path
      end
    end
  end

  describe "GET 'show'" do
    context "as admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :show, id: @admin
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the correct user" do
        get :show, id: @admin
        expect(assigns(:user)).to eq @admin
      end

      it "should be able to view show page of another user" do
        get :show, id: @users.first
        expect(assigns(:user)).to eq @users.first
      end
    end

    context "as regular user" do
      before { sign_in @users.first }

      it "should be successful" do
        get :show, id: @users.first
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the correct user" do
        get :show, id: @users.first
        expect(assigns(:user)).to eq @users.first
      end

      it "should not be able to view show page of another user" do
        get :show, id: @users[1]
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @users.first
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end


  describe "GET 'new'" do
    context "as regular user" do
      it "should redirect to home page" do
        sign_in @users.first
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to root_url
        expect(flash[:notice]).to eq 'You already have an account'
      end
    end

    context "visitor" do
      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end
    end
  end

  describe "GET 'cancel'" do
    context "as regular user" do
      it "should be successful" do
        sign_in @users.first
        get :cancel
        expect(response).to be_success
        expect(response).to render_template :cancel
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :cancel
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
