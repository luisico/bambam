require 'rails_helper'

RSpec.describe SearchController do
  describe "filters" do
    it { is_expected.to use_before_filter :authenticate_user! }
  end

  describe "Get 'search'" do
    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user, email: "besty_name@example.com")
        @user3 = FactoryGirl.create(:user, first_name: "besty_first_name")
        @user4 = FactoryGirl.create(:user, last_name: "besty_last_name")
        sign_in @user
      end

      it "should be a success" do
        get :search, q: 'best'
        expect(response).to be_success
      end

      context "projects and tracks" do
        before do
          @project1 = FactoryGirl.create(:project, name: "best project", users: [@user])
          @track11 = FactoryGirl.create(:track, name: "a track", project: @project1)

          @project2 = FactoryGirl.create(:project, name: "another best project", users: [@user])
          @track21 = FactoryGirl.create(:track, name: "best track", project: @project2)
          @track22 = FactoryGirl.create(:track, name: "a track", project: @project2)
          @track23 = FactoryGirl.create(:track, name: "second best track", project: @project2)

          @project3 = FactoryGirl.create(:project, name: "ok project", users: [@user])
          @track31 = FactoryGirl.create(:track, name: "a track", project: @project3)
          @track32 = FactoryGirl.create(:track, name: "third best track", project: @project3)

          @project4 = FactoryGirl.create(:project, name: "bad project", users: [@user])
          @track41 = FactoryGirl.create(:track, name: "a track", project: @project4)

          @project5 = FactoryGirl.create(:project, name: "so so project", users: [@user])
          @track51 = FactoryGirl.create(:track, name: "b track", project: @project5, path: "tmp/tests/best.bam")

          @project6 = FactoryGirl.create(:project, name: "meh project", users: [@user, @user2])
          @track61 = FactoryGirl.create(:track, name: "a track", project: @project6)

          @project7 = FactoryGirl.create(:project, name: "blah project", users: [@user, @user3])
          @track71 = FactoryGirl.create(:track, name: "a track", project: @project7)

          @project8 = FactoryGirl.create(:project, name: "blerg project", users: [@user, @user4])
          @track81 = FactoryGirl.create(:track, name: "b track", project: @project8)
        end

        it "should be correctly returned and sorted" do
          result = {
            @project1 => { users: [], tracks: [] },
            @project2 => { users: [], tracks: [@track21, @track23] },
            @project3 => { users: [], tracks: [@track32] },
            @project5 => { users: [], tracks: [@track51] },
            @project6 => { users: [@user2], tracks: [] },
            @project7 => { users: [@user3], tracks: [] },
            @project8 => { users: [@user4], tracks: [] }
          }
          get :search, q: 'best'
          expect(assigns(:projects_and_tracks)).to eq result
        end

        it "should be correctly returned and sorted regardless of case" do
          result = {
            @project6 => { users: [@user2], tracks: [] },
            @project7 => { users: [@user3], tracks: [] },
            @project8 => { users: [@user4], tracks: [] }
          }
          get :search, q: 'BESTY'
          expect(assigns(:projects_and_tracks)).to eq result
        end

        it "should not return projects or tracks user doesn't have access to" do
          [@project1, @project3, @project5, @project6, @project7, @project8].each {|p| p.users.delete(@user)}
          result = {
            @project2 => { users: [], tracks:[@track21, @track23] }
          }
          get :search, q: 'best'
          expect(assigns(:projects_and_tracks)).to eq result
        end
      end

      context "groups and users" do
        before do
          @user5 = FactoryGirl.create(:user, email: "good_user@example.com")
          @group1 = FactoryGirl.create(:group, name: "best group", members: [@user, @user2])
          @group2 = FactoryGirl.create(:group, name: "second best group", members: [@user, @user5])
          @group3 = FactoryGirl.create(:group, name: "ok group", members: [@user, @user2])
          @group4 = FactoryGirl.create(:group, name: "bad group", members: [@user5])
          @group5 = FactoryGirl.create(:group, name: "not so bad group", members: [@user, @user3])
          @group6 = FactoryGirl.create(:group, name: "sort of ok group", members: [@user,@user4])
        end

        it "should be correctly returned and sorted" do
          result = {
            @group1 => [@user2],
            @group2 => [],
            @group3 => [@user2],
            @group5 => [@user3],
            @group6 => [@user4]
          }
          get :search, q: 'best'
          expect(assigns(:groups_and_users)).to eq result
        end

        it "should not return groups user doesn't have access to" do
          [@group1, @group3, @group5, @group6].each {|group| group.members.delete(@user)}
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

  describe "#matches_term?" do
    before do
      sign_in FactoryGirl.create(:admin)
      controller.instance_variable_set(:@q, "best")
    end

    context "email" do
      it "returns true for email that includes the matched term" do
        user = FactoryGirl.create(:user, email: "best@example.com")
        expect(controller.send(:matches_term?, user)).to eq true
      end

      it "returns false for email that doesn't include the term" do
        user = FactoryGirl.create(:user, email: "ok@example.com")
        expect(controller.send(:matches_term?, user)).to eq false
      end
    end

    context "first_name" do
      it "returns true for first name that includes the matched term" do
        user = FactoryGirl.create(:user, first_name: "best_name")
        expect(controller.send(:matches_term?, user)).to eq true
      end

      it "returns false for first name that doesn't include the term" do
        user = FactoryGirl.create(:user, first_name: "ok_name")
        expect(controller.send(:matches_term?, user)).to eq false
      end
    end

    context "last_name" do
      it "returns true for first name that includes the matched term" do
        user = FactoryGirl.create(:user, last_name: "best_name")
        expect(controller.send(:matches_term?, user)).to eq true
      end

      it "returns false for first name that doesn't include the term" do
        user = FactoryGirl.create(:user, last_name: "ok_name")
        expect(controller.send(:matches_term?, user)).to eq false
      end
    end
  end
end
