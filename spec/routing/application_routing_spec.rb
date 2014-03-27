require "spec_helper"

describe 'Application' do
  describe "root" do
    it "routes to pages#home" do
      expect(get("/")).to route_to("pages#home")
    end
  end
end
