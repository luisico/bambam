require "spec_helper"

describe "Projects" do
  describe "routes to" do
    it "index" do
      assert_routing({ path: '/projects', method: :get },       { controller: 'projects', action: 'index' })
    end
  end
end

