require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes to #home" do
      assert_routing({ path: '/', method: :get },{ controller: 'pages', action: 'home' })
    end
  end
end
