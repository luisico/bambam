require 'rails_helper'

RSpec.describe StaticPagesController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  describe "GET 'help'" do
    context "as user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be successful" do
        get :help
        expect(response).to be_success
        expect(response).to render_template :help
      end
    end
  end

  context "as a visitor" do
    it "should redirect to the sign in page" do
      get :help
      expect(response).not_to be_success
      expect(response).to redirect_to new_user_session_url
    end
  end
end
