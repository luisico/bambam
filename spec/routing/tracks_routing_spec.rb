require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes" do
      assert_routing({ path: '/tracks', method: :get },{ controller: 'tracks', action: 'index' })
    end
  end
end
