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

  describe "GET 'new'" do
    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new project" do
        get :new
        expect(assigns(:project)).to be_new_record
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'edit'" do
    before { @project = FactoryGirl.create(:project) }

    context "as a signed in user and owner of @project" do
      before { sign_in @project.owner }

      it "should be successful" do
        get :edit, id: @project
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the project" do
        get :edit, id: @project
        expect(assigns(:project)).to eq @project
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :edit, id: @project
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :edit, id: @project
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "Post 'create'" do
    before { @project_attr = FactoryGirl.attributes_for(:project) }

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      context "with valid parameters" do
        it "should be a redirect to the new project show page" do
          post :create, project: @project_attr
          expect(response).to redirect_to project_path(Project.last)
        end

        it "should create a new project" do
          expect{
            post :create, project: @project_attr
          }.to change(Project, :count).by(1)
          expect(assigns(:project)).to eq Project.last
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, project: @project_attr.merge(name: '')
          expect(response).to be_success
          expect(response).to render_template :new
        end

        it "should not create a new project" do
          expect{
            post :create, project: @project_attr.merge(name: '')
          }.not_to change(Project, :count)
          expect(assigns(:project)).to be_new_record
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        post :create, project: @project_attr
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not create a new project" do
        expect{
          post :create, project: @project_attr
        }.not_to change(Project, :count)
      end
    end
  end

  describe "Patch 'update'" do
    before { @project = FactoryGirl.create(:project) }

    context "as a signed in user" do
      before { sign_in @project.owner }

      context 'with valid parameters' do
        before do
          @new_project = FactoryGirl.attributes_for(:project)
        end

        it "should redirect to the updated show page" do
          patch :update, id: @project, project: @new_project
          expect(response).to redirect_to @project
        end

        it "should update the project" do
          patch :update, id: @project, project: @new_project
          @project.reload
          expect(assigns(:project)).to eq @project
          expect(@project.name).to eq @new_project[:name]
        end
      end

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @project, project: {name: ''}
          expect(response).to be_success
          expect(response).to render_template :edit
        end

        it "should not change the project's attributes" do
          expect {
            patch :update, id: @project, project: {name: ''}
            @project.reload
          }.not_to change(@project, :name)
          expect(assigns(:project)).to eq @project
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @project, project: {name: ''}
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the project's attributes" do
        expect{
          patch :update, id: @project, project: {name: ''}
        }.not_to change(@project, :name)
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @project = FactoryGirl.create(:project) }

    context "as a signed in user" do
      before { sign_in @project.owner }

      it "should redirect to project#index" do
        delete :destroy, id: @project
        expect(response).to redirect_to projects_url
      end

      it "should delete the project" do
        expect{
          delete :destroy, id: @project
        }.to change(Project, :count).by(-1)
        expect(assigns(:project)).to eq @project
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @project
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not delete the project" do
        expect{
          delete :destroy, id: @project
        }.not_to change(Project, :count)
      end
    end
  end
end
