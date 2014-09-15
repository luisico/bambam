require 'spec_helper'

describe SearchController do
  describe "Post 'search'" do
    before do
      @project = FactoryGirl.create(:project)
      @track = FactoryGirl.create(:test_track, project: @project)
      @user = FactoryGirl.create(:user, projects: [@project])
    end

    context "as a signed in user" do
      before { sign_in @user }

      context "with valid parameters" do
        it "should be a success" do
          post :search, q: 'best'
          expect(response).to be_success
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        post :search, q: 'best'
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
