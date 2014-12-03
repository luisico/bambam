require 'spec_helper'

describe ProjectsUserController do
  describe "Patch 'update'" do
    before do
      @admin = FactoryGirl.create(:admin)
      @project = FactoryGirl.create(:project,  owner: @admin, users: [FactoryGirl.create(:user)])
      @projects_user = @project.projects_users.last
    end

    context "as an admin and owner of project" do
      before { sign_in @admin }

      context 'with valid parameters' do
        it "should be a success" do
          patch :update, id: @projects_user, projects_user: {read_only: true}, format: 'js'
          expect(response).to be_success
        end

        it "should update the project_user" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: true}, format: 'js'
            @projects_user.reload
          }.to change(@projects_user, :read_only)
        end
      end

      context "with invalid parameters" do
        it "should not update the project_user" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: "99999"}, format: 'js'
            @projects_user.reload
          }.not_to change(@projects_user, :read_only)
        end
      end

      context "with html response" do
        it "raises an error" do
          expect {
            patch :update, id: @projects_user, projects_user: {read_only: true}
          }.to raise_error
        end
      end
    end

    context "as a regular user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should raise an error" do
        expect{
          patch :update, id: @projects_user, projects_user: {read_only: true}, format: 'js'
        }.to raise_error
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @projects_user, projects_user: {read_only: true}, format: 'js'
        expect(response).not_to be_success
      end
    end
  end
end
