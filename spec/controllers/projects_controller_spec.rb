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

    context "as a signed in user and project member" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @user_projects = FactoryGirl.create_list(:project, 3, users: [@user])
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

    context "as a signed user without a project" do
      before { sign_in FactoryGirl.create(:user) }

      it "should redirect to a static contact admin page" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return no project" do
        get :index
        expect(assigns(:projects)).to eq []
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
    before { @project = @projects.first }

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :show, id: @project
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the project" do
        get :show, id: @project
        expect(assigns(:project)).to eq @project
      end
    end

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context "and project member" do
        before { @project.users << @user }

        it "should be successful" do
          get :show, id: @project
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should return the project" do
          get :show, id: @project
          expect(assigns(:project)).to eq @project
        end
      end

      context "not project member" do
        it "should redirect to projects page" do
          get :show, id: @projects.last
          expect(response).not_to be_success
          expect(response).to redirect_to projects_path
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @project
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'new'" do
    context "as an admin" do
      before { sign_in @admin }

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

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should redirect to the projects page" do
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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
    before { @project = @projects.first }

    context "as an admin" do
      before { sign_in @admin }

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

    context "as a signed in user and project member" do
      before do
        user = FactoryGirl.create(:user)
        @project.users << user
        sign_in user
      end

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

    context "as a signed in user but not project member" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :edit, id: @projects.last
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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

    context "as an admin" do
      before { sign_in @admin }

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

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should redirect to the projects page" do
        post :create, project: @project_attr
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end

      it "should not create a new project" do
        expect {
          post :create, project: @project_attr
        }.not_to change(Project, :count)
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
    before do
     @project = @projects.first
     @new_project = FactoryGirl.attributes_for(:project)
    end

    context "as an admin" do
      before { sign_in @admin }

      context 'with valid parameters' do
        before { @user = FactoryGirl.create(:user) }

        it "should redirect to the updated show page" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id])
          expect(response).to redirect_to @project
        end

        it "should update the project" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id])
          @project.reload
          expect(assigns(:project)).to eq @project
          expect(@project.name).to eq @new_project[:name]
          expect(@project.users).to include @user
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

    context "as a signed in user and project member" do
      before { sign_in FactoryGirl.create(:user, projects: [@project]) }

      context "project name" do
        it "should redirect to the projects path" do
          patch :update, id: @project, project: @new_project
          expect(response).not_to be_success
          expect(response).to redirect_to projects_path
        end

        it "should not change the project's attributes" do
          expect{
            patch :update, id: @project, project: @new_project
          }.not_to change(@project, :name)
        end
      end

      context "project users" do
        before { @user = FactoryGirl.create(:user) }

        it "should redirect to the projects path" do
          patch :update, id: @project, project: { user_ids: [@user.id] }
          expect(response).not_to be_success
          expect(response).to redirect_to projects_path
        end

        it "should not change the project's attributes" do
          expect{
            patch :update, id: @project, project: { user_ids: [@user.id] }
          }.not_to change(@project, :users)
        end
      end

      context "project tracks" do
        before { @track = FactoryGirl.create(:test_track, project: @project) }

        it "should redirect to the updated show page" do
          patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
          expect(response).to redirect_to @project
        end

        it "should update the project" do
          patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
          @track.reload
          expect(assigns(:project)).to eq @project
          expect(@track.name).to eq('new_name')
        end
      end

      context "track project" do
        before do
          @track = FactoryGirl.create(:test_track, project: @project)
          @another_project = FactoryGirl.create(:project)
        end

        it "should redirect to the projects path" do
          patch :update, id: @project, project: {tracks_attributes: {"0" => {project_id: @another_project.id}}}
          expect(response).not_to be_success
          expect(response).to redirect_to projects_path
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @project, project: @new_project
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the project's attributes" do
        expect{
          patch :update, id: @project, project: @new_project
        }.not_to change(@project, :name)
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @project = FactoryGirl.create(:project, owner: @admin) }

    context "as an admin" do
      before { sign_in @admin }

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

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }
      it "should redirect to the projects page" do
        delete :destroy, id: @project
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end

      it "should not delete the project" do
        expect{
          delete :destroy, id: @project
        }.not_to change(Project, :count)
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
