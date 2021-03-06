require 'rails_helper'

RSpec.describe UsersController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

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

      it "should return all the groups" do
        groups = FactoryGirl.create_list(:group, 3)
        get :index
        expect(assigns(:groups)).to eq groups
      end

      it "should return all the projects" do
        projects = FactoryGirl.create_list(:project, 3)
        get :index
        expect(assigns(:projects)).to eq projects
      end
    end

    context "as manager" do
      before do
        @manager = FactoryGirl.create(:manager)
        sign_in @manager
      end

      it "should return only projects manager owns" do
        projects = FactoryGirl.create_list(:project, 3)
        manager_projects = FactoryGirl.create_list(:project, 3, owner: @manager)
        get :index
        expect(assigns(:projects).sort).to eq manager_projects.sort
      end

      it "should return only groups manager owns or is a member of" do
        groups = FactoryGirl.create_list(:group, 3)
        owned_groups = FactoryGirl.create_list(:group, 3, owner: @manager)
        member_of_groups = FactoryGirl.create_list(:group, 3, members: [@manager])
        get :index
        expect(assigns(:groups)).to eq owned_groups + member_of_groups
      end
    end

    context "as regular user" do
      before { sign_in @users.first }

      it "should be denied" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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

      context "page of another user" do
        it "should be successful" do
          get :show, id: @users.first
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should return the correct user" do
          get :show, id: @users.first
          expect(assigns(:user)).to eq @users.first
        end

        it "should return the correct projects" do
          project = FactoryGirl.create(:project)
          user_on_projects = FactoryGirl.create_list(:project, 3, users: @users)
          get :show, id: @users.first
          expect(assigns(:projects)).to eq user_on_projects
        end
      end

      context "page of a manager" do
        it "should return the correct projects" do
          manager = FactoryGirl.create(:manager)
          project = FactoryGirl.create(:project)
          user_on_projects = FactoryGirl.create_list(:project, 2, users: [manager])
          owned_projects = FactoryGirl.create_list(:project, 2, owner: manager)
          get :show, id: manager
          expect(assigns(:projects)).to eq (user_on_projects | owned_projects)
        end
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

      it "should return the correct projects" do
        project = FactoryGirl.create(:project)
        user_on_projects = FactoryGirl.create_list(:project, 3, users: [@users.first])
        get :show, id: @users.first
        expect(assigns(:user)).to eq @users.first
        expect(assigns(:projects)).to eq user_on_projects
      end

      it "should not be able to view show page of another user" do
        get :show, id: @users[1]
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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
