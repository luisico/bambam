require 'spec_helper'

describe SearchController do
  describe "Get 'search'" do
    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user, email: "second_best@example.com")
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

          @project5 = FactoryGirl.create(:project, name: "so so project", users: [@user])
          @track51 = FactoryGirl.create(:test_track, name: "b track", project: @project5, path: "tmp/tests/best.bam")

          @project6 = FactoryGirl.create(:project, name: "so so project", users: [@user, @user2])
          @track61 = FactoryGirl.create(:test_track, name: "a track", project: @project6)
        end

        it "should be correctly returned and sorted" do
          result = {
            @project1 => { users: [], tracks: [] },
            @project2 => { users: [], tracks: [@track21, @track23] },
            @project3 => { users: [], tracks: [@track32] },
            @project5 => { users: [], tracks: [@track51] },
            @project6 => { users: [@user2], tracks: [] }
          }
          get :search, q: 'best'
          expect(assigns(:projects_and_tracks)).to eq result
        end

        it "should not return projects or tracks user doesn't have access to" do
          [@project1, @project3, @project5, @project6].each {|p| p.users.delete(@user)}
          result = {
            @project2 => { users: [], tracks:[@track21, @track23] },
          }
          get :search, q: 'best'
          expect(assigns(:projects_and_tracks)).to eq result
        end
      end

      context "groups and users" do
        before do
          @user3 = FactoryGirl.create(:user, email: "good_user@example.com")
          @group1 = FactoryGirl.create(:group, name: "best project", members: [@user, @user2])
          @group2 = FactoryGirl.create(:group, name: "second best project", members: [@user, @user3])
          @group3 = FactoryGirl.create(:group, name: "ok project", members: [@user, @user2])
          @group4 = FactoryGirl.create(:group, name: "bad project", members: [@user3])
        end

        it "should be correctly returned and sorted" do
          result = {
            @group1 => [@user2],
            @group2 => [],
            @group3 => [@user2]
          }
          get :search, q: 'best'
          expect(assigns(:groups_and_users)).to eq result
        end

        it "should not return groups user doesn't have access to" do
          [@group1, @group3].each {|group| group.members.delete(@user)}
          result = {
            @group2 => []
          }
          get :search, q: 'best'
          expect(assigns(:groups_and_users)).to eq result
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
