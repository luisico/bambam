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

    context "as an manager" do
      it "should redirect to users page" do
        sign_in FactoryGirl.create(:manager)
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
        expect(response).to redirect_to projects_path
      end
    end

    context "visitor" do
      it "should redirect to home page" do
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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

    context "as an manager" do
      before { sign_in FactoryGirl.create(:manager) }

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
        expect(response).to redirect_to projects_path
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
        expect(response).to redirect_to projects_path
      end

      it "should not create a new user" do
        expect {
          post :create, user: @new_user
        }.not_to change(User, :count)
      end
    end
  end

  describe "#add_invitee_to_projects" do
    before { @user = FactoryGirl.create(:user) }

    context "with valid project_id parameter" do
      it "adds right projects" do
        projects = FactoryGirl.create_list(:project, 3)
        controller.params = {project_ids: [projects.first.id, projects.last.id]}

        expect {
          controller.send(:add_invitee_to_projects, @user)
        }.to change(@user.projects, :count).by(2)
        expect(@user.projects).to eq [projects.first, projects.last]
      end

      it "adds a single project" do
        project = FactoryGirl.create(:project)
        controller.params = {project_ids: project}
        expect {
          controller.send(:add_invitee_to_projects, @user)
        }.to change(@user.projects, :count).by(1)
        expect(@user.projects).to eq [project]
      end
    end

    context "with invalid parameters" do
      it "does not add non existant projects" do
        controller.params = {project_ids: [999, 9999]}
        expect {
          controller.send(:add_invitee_to_projects, @user)
        }.not_to change(@user.projects, :count)
      end

      it "does not add empty or blank list of projects" do
        ['', nil, []].each do |ids|
          controller.params = {project_ids: ids}
          expect {
            controller.send(:add_invitee_to_projects, @user)
          }.not_to change(@user.projects, :count)
        end
      end
    end
  end

  describe "#invite_resource" do
    before { sign_in FactoryGirl.create(:admin) }

    context "manager parameter" do
      it "adds role when requested" do
        controller.params = {user: {email: "test@example.com"}, manager: "1"}
        expect {
          controller.send(:invite_resource)
        }.to change(User, :count).by(1)
        expect(User.last.has_role? :manager).to be true
      end

      it "doesn't add role when not requested" do
        controller.params = {user: {email: "test@example.com"}}
        expect {
          controller.send(:invite_resource)
        }.to change(User, :count).by(1)
        expect(User.last.has_role? :manager).to be false
      end
    end

    context "project-ids parameter" do
      before { @projects = FactoryGirl.create_list(:project, 2) }

      it "adds project when requested" do
        controller.params = {user: {email: "test@example.com"}, project_ids: @projects.map(&:id)}
        expect {
          controller.send(:invite_resource)
        }.to change(User, :count).by(1)
        expect(User.last.projects).to eq @projects
      end

      it "doesn't add project when not requested" do
        controller.params = {user: {email: "test@example.com"}}
        expect {
          controller.send(:invite_resource)
        }.to change(User, :count).by(1)
        expect(User.last.projects).to eq []
      end
    end
  end
end
