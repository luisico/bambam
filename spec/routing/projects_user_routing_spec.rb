require "spec_helper"

describe "ProjectsUser" do
  describe "routes to" do
    it "the update action" do
      assert_routing({ path: '/projects/1', method: :patch},    { controller: 'projects', action: 'update', id: '1'})
    end
  end
end
