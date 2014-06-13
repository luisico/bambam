require 'spec_helper'

describe ProjectsController do
  before do
    @admin = FactoryGirl.create(:admin)
    @projects = FactoryGirl.create_list(:project, 3)
  end

  describe "GET 'index'" do
    context "as admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return all projects" do
        get :index
        expect(assigns(:projects)).to eq @projects
      end
    end

    context "as a signed in user and project owner" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @user_projects = FactoryGirl.create_list(:project, 3, owner: @user)
      end

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return only my projects" do
        get :index
        expect(assigns(:projects)).to eq @user_projects
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

  describe "GET 'show'" do
    context "as a signed in user and project owner" do
      before {sign_in @admin}

      it "should be successful" do
        get :show, id: @projects.first
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the project" do
        get :show, id: @projects.first
        expect(assigns(:project)).to eq @projects.first
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @projects.first
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
