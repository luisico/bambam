require 'spec_helper'

describe ApplicationController do
  describe "CanCan AccessDenied exceptions" do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    it "redirect to the tracks page" do
      get :index
      expect(response).to redirect_to(tracks_path)
    end
  end

  describe "Exception Notification" do
    pending "should send an email"
  end

  describe "Basic Authentication" do
    controller do
      def index
        authenticate_user!
        render text: 'hello world'
      end
    end

    it "with valid credentials should grant access" do
      user = FactoryGirl.create(:user)
      auth = Base64.encode64("#{user.email}:#{user.password}")
      @request.headers.merge!({
        "Authorization" => "Basic #{auth}"
      })

      get :index
      expect(response).to be_success
      expect(response.body).to eq 'hello world'
    end

    it "with invalid credentials should not grant access" do
      @request.headers.merge!({
        "Authorization" => "Basic somestring"
      })

      get :index
      expect(response).not_to be_success
      expect(response).to redirect_to new_user_session_url
    end
  end
end
