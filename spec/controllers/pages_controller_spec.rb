require 'spec_helper'

describe PagesController do
  describe "GET 'home'" do
    it "should be successful" do
      get :home
      expect(response).to be_success
      expect(response).to render_template :home
    end
  end
end
