require "spec_helper"

describe "StaticPages" do
  describe "routes to" do
    it "static pages" do
      assert_routing({ path: '/help', method: :get }, { controller: 'static_pages', action: 'help' })
    end
  end
end
