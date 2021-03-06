require 'rails_helper'

RSpec.describe ProjectsUsersController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  describe "Patch 'update'" do
    before do
      @admin = FactoryGirl.create(:admin)
      @project = FactoryGirl.create(:project,  owner: @admin, users: [FactoryGirl.create(:user)])
      @projects_user = @project.projects_users.last
    end

    context "as an admin and owner of project" do
      before { sign_in @admin }

      it { is_expected.to permit(:read_only).for(:update, params: {id: @projects_user, format: :js}) }

      context 'with valid parameters' do
        it "should be a success" do
          patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
          expect(response).to be_success
        end

        it "should update the projects user" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
            @projects_user.reload
          }.to change(@projects_user, :read_only)
        end
      end

      context "with invalid parameters" do
        it "should not update the projects user" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: "99999"}, format: :js
            @projects_user.reload
          }.not_to change(@projects_user, :read_only)
        end
      end

      context "with html response" do
        it "raises an error" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: true}
          }.to raise_error ActionView::MissingTemplate
        end
      end
    end

    context "as a regular user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end

      it "should not update the projects user" do
        expect{
          patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
        }.not_to change(@projects_user, :read_only)
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not update the projects user" do
        expect{
          patch :update, id: @projects_user, projects_user: {read_only: true}, format: :js
        }.not_to change(@projects_user, :read_only)
      end
    end
  end
end
