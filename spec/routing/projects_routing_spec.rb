require "spec_helper"

describe "Projects" do
  describe "routes to" do
    it "index" do
      assert_routing({ path: '/projects', method: :get },       { controller: 'projects', action: 'index' })
    end
    it "show" do
      assert_routing({ path: '/projects/1', method: :get },     { controller: 'projects', action: 'show', id: '1' })
    end
  end
end

