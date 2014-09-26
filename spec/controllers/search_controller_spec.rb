require 'spec_helper'

describe SearchController do
  describe "Get 'search'" do
    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user, email: "best_user@example.com")
        sign_in @user
      end

      it "should be a success" do
        get :search, q: 'best'
        expect(response).to be_success
      end

      context "projects and tracks" do
        before do
          @project1 = FactoryGirl.create(:project, name: "best project", users: [@user])
          @track11 = FactoryGirl.create(:test_track, name: "a track", project: @project1)

          @project2 = FactoryGirl.create(:project, name: "another best project", users: [@user])
          @track21 = FactoryGirl.create(:test_track, name: "best track", project: @project2)
          @track22 = FactoryGirl.create(:test_track, name: "a track", project: @project2)
          @track23 = FactoryGirl.create(:test_track, name: "second best track", project: @project2)

          @project3 = FactoryGirl.create(:project, name: "ok project", users: [@user])
          @track31 = FactoryGirl.create(:test_track, name: "a track", project: @project3)
          @track32 = FactoryGirl.create(:test_track, name: "third best track", project: @project3)

          @project4 = FactoryGirl.create(:project, name: "bad project", users: [@user])
          @track41 = FactoryGirl.create(:test_track, name: "a track", project: @project4)
        end

        it "should be correctly returned and sorted" do
          result = {
            @project1 => [],
            @project2 => [@track21, @track23],
            @project3 => [@track32]
          }
          get :search, q: 'best'
          expect(assigns(:projects_and_tracks)).to eq result
        end

        it "should not return projects or tracks user doesn't have access to" do
          pending
        end
      end
    end

    # context "groups and users" do
    #   it "should be correctly returned and sorted" do
    #     groups_and_users = {
    #       @group => [@user],
    #       FactoryGirl.create(:group, name: "ok_group", members: [@user]) => [@user]
    #     }
    #   end
    # end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :search, q: 'best'
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
