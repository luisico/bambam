require 'spec_helper'

describe SearchController do
  describe "Get 'search'" do
    context "as a signed in user" do
      before {
        sign_in @user = FactoryGirl.create(:user, email: "best_user@example.com")
        @project = FactoryGirl.create(:project, name: "best_project", users: [@user])
        @track = FactoryGirl.create(:test_track, name: "best_track", project: @project)
        @group = FactoryGirl.create(:group, name: "good_project", members: [@user])
      }

      it "should be a success" do
        get :search, q: 'best'
        expect(response).to be_success
      end

      it "should return two hashes of hashes" do
        get :search, q: 'best'
        expect(assigns(:projects_and_tracks)).to eq @project =>[@track]
        expect(assigns(:groups_and_users)).to eq @group =>[@user]
      end

      it "should return valid search results" do
        projects_and_tracks = {
          @project => [@track],
          FactoryGirl.create(:project, name: "good_project", users: [@user]) => [
            FactoryGirl.create(:test_track, name: "second_best_track", project: Project.last)
          ]
        }
        groups_and_users = {
          @group => [@user],
          FactoryGirl.create(:group, name: "ok_group", members: [@user]) => [@user]
        }

        get :search, q: 'best'
        [:projects_and_tracks, :groups_and_users].each do |col|
          expect(assigns(col)).to eq eval("#{col.to_s}")
        end
      end

      it "should not return invalid search results" do
        @user.update_attributes(email: "good_user@example.com")
        projects_and_tracks = {
          FactoryGirl.create(:project, name: "good_project", users: [@user]) => [
            FactoryGirl.create(:test_track, name: "good_track", project: Project.last)
          ]
        }
        groups_and_users = {
          FactoryGirl.create(:group, name: "ok_group", members: [@user]) => [@user]
        }

        get :search, q: 'best'
        [:projects_and_tracks, :groups_and_users].each do |col|
          expect(assigns(col)).not_to eq eval("#{col.to_s}")
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :search, q: 'best'
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
