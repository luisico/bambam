require 'spec_helper'

describe ProjectsController do
  describe "GET 'index'" do
    before { @projects = FactoryGirl.create_list(:project, 3) }

    context "as admin" do
      before { sign_in FactoryGirl.create(:admin) }

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
    before { @project = FactoryGirl.create(:project) }

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

      it "should be successful" do
        get :show, id: @project
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the project" do
        get :show, id: @project
        expect(assigns(:project)).to eq @project
      end

      it "should return the projects_users" do
        get :show, id: @project
        expect(assigns(:projects_users)).to eq @project.projects_users
      end
    end

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context "and project user" do
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

        it "should not return the projects_users" do
          get :show, id: @project
          expect(assigns(:projects_users)).to eq nil
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
    context "as an admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        sign_in @admin
     end

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
        expect(assigns(:project).owner).to eq @admin
      end

      it "should add signed in user to users" do
        get :new
        expect(assigns(:project).users).to include @admin
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
    before { @project = FactoryGirl.create(:project) }

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

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

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

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
      @admin = FactoryGirl.create(:admin)
      @project = FactoryGirl.create(:project,  owner: @admin)
      @new_project = FactoryGirl.attributes_for(:project)
    end

    context "as an admin and owner of project" do
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

        it "should not change ownership" do
          expect {
            patch :update, id: @project, project: @new_project
          }.not_to change(@project, :owner)
        end

         it "should add owner to users if not present" do
          patch :update, id: @project, project: @new_project.merge(user_ids: [])
          expect(assigns(:project).users).to include @project.owner
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

    context "as an admin" do
      before do
       @other_admin = FactoryGirl.create(:admin)
       sign_in @other_admin
     end

      it "should not change ownership" do
        expect {
          patch :update, id: @project, project: @new_project
        }.not_to change(@project, :owner)
      end

      it "should add owner to users if not present" do
        patch :update, id: @project, project: @new_project.merge(user_ids: [])
        expect(assigns(:project).users).to include @project.owner
      end

      it "should not add other admin to users" do
        patch :update, id: @project, project: @new_project.merge(user_ids: [])
        expect(assigns(:project).users).not_to include @other_admin
      end
    end

    context "as a signed in user and project user" do
      before do
        sign_in FactoryGirl.create(:user, projects: [@project])
        @track = FactoryGirl.create(:test_track, project: @project)
      end

      context 'with valid parameters' do
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

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @project, project: {tracks_attributes: {"0" => {name: '', id: @track.id}}}
          expect(response).to be_success
          expect(response).to render_template :edit
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @project, project: {tracks_attributes: {"0" => {name: '', id: @track.id}}}
            @track.reload
          }.not_to change(@track, :name)
          expect(assigns(:project)).to eq @project
        end
      end
    end

    context "as a signed in user" do
      before do
        sign_in FactoryGirl.create(:user)
        @track = FactoryGirl.create(:test_track, project: @project)
      end

      context 'with valid parameters' do
        it "should not be a success" do
          patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
          expect(response).not_to be_success
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
            @track.reload
          }.not_to change(@track, :name)
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
    before { @project = FactoryGirl.create(:project) }

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

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

  describe "#has_admin_attr?" do
    context "should be true with parameter" do
      it "users" do
        controller.params = {project: {user_ids: [9999]}}
        expect(controller.send(:has_admin_attr?)).to be_true
      end

      it "name" do
        controller.params = {project: {name: 'new_name'}}
        expect(controller.send(:has_admin_attr?)).to be_true
      end

      it "tracks with project_id" do
        controller.params = {project: {tracks_attributes: {'0' => {name: 'new_name', project_id: [9999]}}}}
        expect(controller.send(:has_admin_attr?)).to be_true
      end
    end

    context "it should be false with parameter" do
      it "tracks without project_id" do
        controller.params = {project: {tracks_attributes: {'0' => {name: 'new_name', id: 9999}}}}
        expect(controller.send(:has_admin_attr?)).to be_false
      end

      it "empty" do
        controller.params = {project: {}}
        expect(controller.send(:has_admin_attr?)).to be_false
      end
    end
  end
end
