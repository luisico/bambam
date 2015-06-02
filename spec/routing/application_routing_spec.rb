require 'rails_helper'

RSpec.describe 'Application' do
  describe "root" do
    it "routes to sign in form" do
      expect(get("/")).to route_to("devise/sessions#new")
    end
  end
end
