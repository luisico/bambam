require 'spec_helper'

describe Users::InvitationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'new'" do
    context "as an admin" do
      it "should redirect to users page" do
        sign_in FactoryGirl.create(:admin)
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to users_path
      end
    end

    context "as an inviter" do
      it "should redirect to users page" do
        sign_in FactoryGirl.create(:inviter)
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to users_path
      end
    end

    context "as regular user" do
      it "should redirect to home page" do
        sign_in FactoryGirl.create(:user)
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "visitor" do
      it "should redirect to home page" do
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end
  end

  describe "Post 'create'" do
    before { @new_user = FactoryGirl.attributes_for(:user) }

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

      context "with valid parameters" do
        it "should be a redirect to the users page" do
          post :create, user: @new_user
          expect(response).to redirect_to users_path
        end

        it "should create a new user" do
          expect {
            post :create, user: @new_user
          }.to change(User, :count).by(1)
          expect(assigns(:user)).to eq User.last
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, user: @new_user.merge(email: '')
          expect(response).to be_success
          expect(response).to render_template 'users/index'
        end

        it "should not create a new user" do
          expect {
            post :create, user: @new_user.merge(email: '')
          }.not_to change(User, :count)
          expect(assigns(:user)).to be_new_record
        end
      end
    end

    context "as an inviter" do
      before { sign_in FactoryGirl.create(:inviter) }

      context "with valid parameters" do
        it "should be a redirect to the users page" do
          post :create, user: @new_user
          expect(response).to redirect_to users_path
        end

        it "should create a new user" do
          expect {
            post :create, user: @new_user
          }.to change(User, :count).by(1)
          expect(assigns(:user)).to eq User.last
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, user: @new_user.merge(email: '')
          expect(response).to be_success
          expect(response).to render_template 'users/index'
        end

        it "should not create a new user" do
          expect {
            post :create, user: @new_user.merge(email: '')
          }.not_to change(User, :count)
          expect(assigns(:user)).to be_new_record
        end
      end
    end

    context "as a user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        post :create, user: @new_user
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end

      it "should not create a new user" do
        expect {
          post :create, user: @new_user
        }.not_to change(User, :count)
      end
    end

    context "as a visitor" do
      it "should redirect to the tracks page" do
        post :create, user: @new_user
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end

      it "should not create a new user" do
        expect {
          post :create, user: @new_user
        }.not_to change(User, :count)
      end
    end
  end
end
