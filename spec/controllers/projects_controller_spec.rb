require 'spec_helper'

describe ProjectsController do
  before { @manager = FactoryGirl.create(:manager) }

  describe "GET 'index'" do
    before { @projects = FactoryGirl.create_list(:project, 3, owner: @manager) }

    context "as a manager" do
      before { sign_in @manager }

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

    context "as a signed in user and project user" do
      before do
        user = FactoryGirl.create(:user)
        sign_in user
        @user_projects = FactoryGirl.create_list(:project, 3, users: [user])
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
    before { @project = FactoryGirl.create(:project, owner: @manager) }

    context "as a manager" do
      before { sign_in @manager }

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

      context "and project user" do
        before do
          @project.users << @user
          @regular_users = [@project.owner, @user]
          @read_only_users = FactoryGirl.create_list(:user, 2, projects: [@project])
          @read_only_users.each {|u| u.projects_users.first.update_attributes(read_only: true)}
        end

        it "should be successful" do
          get :show, id: @project
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should return the project" do
          get :show, id: @project
          expect(assigns(:project)).to eq @project
        end

        it "should return the regular project users" do
          get :show, id: @project
          expect(assigns(:regular_users)).to eq @regular_users
        end

        it "should return the read-only project users" do
          get :show, id: @project
          expect(assigns(:read_only_users)).to eq @read_only_users
        end
      end

      context "not project user" do
        it "should redirect to projects page" do
          get :show, id: FactoryGirl.create(:project)
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
    context "as a manager" do
      before { sign_in @manager }

      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new project" do
        get :new
        expect(assigns(:project)).to be_new_record
        expect(assigns(:project)).to be_kind_of Project
      end

      it "should assign ownership to signed in user" do
        get :new
        expect(assigns(:project).owner).to eq @manager
      end

      it "should add signed in user to users" do
        get :new
        expect(assigns(:project).users).to include @manager
      end
    end

    context "as a signed in user" do
      it "should be denied" do
        sign_in FactoryGirl.create(:user)
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
    before { @project = FactoryGirl.create(:project, owner: @manager) }

    context "as a manager" do
      before { sign_in @manager }

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

    context "as a signed in user and project user" do
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

    context "as a signed in user but not project user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :edit, id: FactoryGirl.create(:project)
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

    context "as a manager" do
      before { sign_in @manager }

      context "with valid parameters" do
        it "should be a a success" do
          post :create, project: @project_attr, format: 'js'
          expect(response).to be_success
        end

        it "should create a new project" do
          expect{
            post :create, project: @project_attr, format: 'js'
          }.to change(Project, :count).by(1)
          expect(assigns(:project)).to eq Project.last
        end
      end

      context "with invalid parameters" do
        it "should not create a new project" do
          expect{
            post :create, project: @project_attr.merge(name: ''), format: 'js'
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
      @project = FactoryGirl.create(:project,  owner: @manager)
      @new_project = FactoryGirl.attributes_for(:project)
    end

    context "as a manager and owner of project" do
      before { sign_in @manager }

      context 'with valid parameters' do
        before { @user = FactoryGirl.create(:user) }

        it "should render the update template" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id]), format: :js
          expect(response).to render_template :update
        end

        it "should update the project" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id]), format: :js
          @project.reload
          expect(assigns(:project)).to eq @project
          expect(@project.name).to eq @new_project[:name]
          expect(@project.users).to include @user
        end

        it "should not change ownership" do
          expect {
            patch :update, id: @project, project: @new_project, format: :js
          }.not_to change(@project, :owner)
        end

        it "should add owner to users if not present" do
          patch :update, id: @project, project: @new_project.merge(user_ids: []), format: :js
          expect(assigns(:project).users).to include @project.owner
        end
      end

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @project, project: {name: ''}, format: :js
          expect(response).to be_success
          expect(response).to render_template :update
        end

        it "should not change the project's attributes" do
          expect {
            patch :update, id: @project, project: {name: ''}, format: :js
            @project.reload
          }.not_to change(@project, :name)
          expect(assigns(:project)).to eq @project
        end
      end
    end

    context "as an admin" do
      before do
       @admin = FactoryGirl.create(:admin)
       sign_in @admin
     end

      it "should not change ownership" do
        expect {
          patch :update, id: @project, project: @new_project, format: :js
        }.not_to change(@project, :owner)
      end

      it "should add owner to users if not present" do
        patch :update, id: @project, project: @new_project.merge(user_ids: []), format: :js
        expect(assigns(:project).users).to include @project.owner
      end

      it "should not add admin to users" do
        patch :update, id: @project, project: @new_project.merge(user_ids: []), format: :js
        expect(assigns(:project).users).not_to include @admin
      end
    end

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'with valid parameters' do
        it "should not be a success" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id]), format: :js
          expect(response).not_to be_success
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id]), format: :js
            @project.reload
          }.not_to change(@project, :users)
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
    before { @project = FactoryGirl.create(:project, owner: @manager) }

    context "as a manager" do
      before { sign_in @manager }

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
