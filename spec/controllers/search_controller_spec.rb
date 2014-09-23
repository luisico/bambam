require 'spec_helper'

describe SearchController do
  describe "Get 'search'" do
    context "as a signed in user" do
      before do
        @projects_and_tracks = {FactoryGirl.create(:project, name: "best_project") => [
                                FactoryGirl.create(:test_track, name: "best_track", project: Project.last)
                                ],
                                FactoryGirl.create(:project, name: "good_project") => [
                                FactoryGirl.create(:test_track, name: "second_best_track", project: Project.last)]
                                }
        @groups_and_users = {FactoryGirl.create(:group, name: "best_group") => [
                            FactoryGirl.create(:user,
                                                email: "best_user@example.com",
                                                projects: @projects_and_tracks.keys[0..1],
                                                groups: Group.where(name: 'best_group'))]
                            }
        sign_in User.where(email: "best_user@example.com").first
      end

      context "with valid parameters" do
        it "should be a success" do
          get :search, q: 'best'
          expect(response).to be_success
        end

        it "should return only valid search results" do
          [:project, :test_track, :group, :user].each do |model|
            FactoryGirl.create(model)
          end
          get :search, q: 'best'
          [:projects, :tracks, :groups, :users].each do |col|
            expect(assigns(col)).to eq instance_variable_get("@#{col.to_s}")
          end
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
