require 'rails_helper'

# TODO: add specs for html/js only requests

RSpec.describe ProjectsController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

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
        expect(assigns(:projects).sort).to eq @projects.sort
      end
    end

    context "as a signed in user and project user" do
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

      it "should correctly filter tracks" do
        project1 = FactoryGirl.create(:project, name: "best_project", users: [@user])
        project2 = FactoryGirl.create(:project, description: "bestest", users: [@user])
        project3 = FactoryGirl.create(:project, owner: FactoryGirl.create(:manager, email: 'best@example.com'), users: [@user])
        project4 = FactoryGirl.create(:project, owner: FactoryGirl.create(:manager, first_name: 'best'), users: [@user])
        project5 = FactoryGirl.create(:project, owner: FactoryGirl.create(:manager, last_name: 'best'), users: [@user])

        get :index, filter: 'best'
        expect(assigns(:projects)).to eq [project1, project2, project3, project4, project5]
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
          FactoryGirl.create_list(:user, 2, projects: [@project]).each do |u|
            u.projects_users.first.update_attributes(read_only: true)
          end
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
      end

      context "not project user" do
        it "should redirect to projects page" do
          get :show, id: FactoryGirl.create(:project)
          expect(response).not_to be_success
          expect(response).to redirect_to projects_url
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
    end

    context "as a signed in user" do
      it "should be denied" do
        sign_in FactoryGirl.create(:user)
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to projects_url
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
        xhr :get, :edit, id: @project, format: :js
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the project" do
        xhr :get, :edit, id: @project, format: :js
        expect(assigns(:project)).to eq @project
      end
    end

    context "as a signed in user and project user" do
      before do
        user = FactoryGirl.create(:user)
        @project.users << user
        sign_in user
      end

      it "should not be successful" do
        xhr :get, :edit, id: @project, format: :js
        expect(response).not_to be_success
        expect(response.status).to eq 403
      end
    end

    context "as a signed in user but not project user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        xhr :get, :edit, id: FactoryGirl.create(:project), format: :js
        expect(response).not_to be_success
        expect(response.status).to eq 403
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        xhr :get, :edit, id: @project, format: :js
        expect(response).not_to be_success
        expect(response.status).to eq 401
      end
    end
  end

  describe "Post 'create'" do
    before { @project_attr = FactoryGirl.attributes_for(:project) }

    context "as a manager" do
      before { sign_in @manager }

      it { is_expected.to permit(:name).for(:create, params: {format: :js}) }

      context "with valid parameters" do
        it "should be a success" do
          post :create, project: @project_attr, format: :js
          expect(response).to be_success
          expect(response).to render_template :create
        end

        it "should create a new project" do
          expect{
            post :create, project: @project_attr, format: :js
          }.to change(Project, :count).by(1)
          expect(assigns(:project)).to eq Project.last
        end

        it "should assign ownership to signed in user" do
          post :create, project: @project_attr, format: :js
          expect(assigns(:project).owner).to eq @manager
        end
      end

      context "with invalid parameters" do
        before { @project_attr.merge!(name: '') }

        it "should be a success" do
          post :create, project: @project_attr, format: :js
          expect(response).to be_success
          expect(response).to render_template :create
        end

        it "should not create a new project" do
          expect{
            post :create, project: @project_attr, format: :js
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
        expect(response).to redirect_to projects_url
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
      @new_project_attrs = FactoryGirl.attributes_for(:project)
    end

    context "as a manager and owner of project" do
      before { sign_in @manager }

      context "update the name" do
        it { is_expected.to permit(:name, user_ids: []).for(:update, params: {id: @project, project: @new_project_attrs, format: :json}) }

        context "with valid parameters" do
          it "should be a success without content" do
            patch :update, id: @project, project: @new_project_attrs, format: :json
            expect(response.status).to eq 204       # no content
          end

          it "should update the project's name'" do
            expect {
              patch :update, id: @project, project: @new_project_attrs, format: :json
              @project.reload
            }.to change(@project, :name).to @new_project_attrs[:name]
            expect(assigns(:project)).to eq @project
          end
        end

        context "with invalid parameters" do
          it "should response with unprocessable entity" do
            patch :update, id: @project, project: {name: ''}, format: :json
            expect(response.status).to eq 422       # unprocessable entity
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json[0]).to eq "Name #{I18n.t('errors.messages.blank')}"
          end

          it "should not change the project's name" do
            expect {
              patch :update, id: @project, project: {name: ''}, format: :json
              @project.reload
            }.not_to change(@project, :name)
            expect(assigns(:project)).to eq @project
          end
        end
      end

      context "update the users" do
        it { is_expected.to permit(:name, user_ids: []).for(:update, params: {id: @project, project: @new_project_attrs, format: :js}) }

        context "with valid parameters" do
          before do
            @user = FactoryGirl.create(:user)
            @new_project_attrs = {user_ids: [@user.id]}
          end

          it "should render the update template" do
            patch :update, id: @project, project: @new_project_attrs, format: :js
            expect(response).to be_success
            expect(response).to render_template :update
          end

          it "should update the project's users'" do
            patch :update, id: @project, project: @new_project_attrs, format: :js
            expect(@project.reload.users).to include @user
          end

          it "should not change ownership" do
            expect {
              patch :update, id: @project, project: @new_project_attrs.merge(owner_id: FactoryGirl.create(:user).id), format: :js
              @project.reload
            }.not_to change(@project, :owner)
          end
        end

        context "with invalid parameters" do
          it "should render the edit template" do
            patch :update, id: @project, project: {user_ids: ''}, format: :js
            expect(response).to be_success
            expect(response).to render_template :update
          end

          it "should not change the project's users" do
            old_users = @project.users
            patch :update, id: @project, project: {user_ids: ''}, format: :js
            expect(@project.reload.users).to eq old_users
            expect(assigns(:project)).to eq @project
          end
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
          patch :update, id: @project, project: @new_project_attrs.merge(owner_id: FactoryGirl.create(:user).id), format: :js
          @project.reload
        }.not_to change(@project, :owner)
      end

      it "should not add admin to users" do
        patch :update, id: @project, project: @new_project_attrs.merge(user_ids: []), format: :js
        expect(@project.reload.users).not_to include @admin
      end
    end

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'with valid parameters' do
        it "should not be a success" do
          patch :update, id: @project, project: @new_project_attrs, format: :js
          expect(response).not_to be_success
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @project, project: @new_project_attrs, format: :js
            @project.reload
          }.not_to change(@project, :name)
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @project, project: @new_project_attrs
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the project's attributes" do
        expect{
          patch :update, id: @project, project: @new_project_attrs
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
        expect(response).to redirect_to projects_url
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
