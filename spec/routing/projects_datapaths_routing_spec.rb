require "spec_helper"

describe "ProjectsDatapaths" do
  describe "routes to" do
    it "the index and show actions" do
      assert_routing({ path: '/projects_datapaths', method: :post },       { controller: 'projects_datapaths', action: 'create' })
      assert_routing({ path: '/projects_datapaths/browser', method: :get}, { controller: 'projects_datapaths', action: 'browser'})
    end
  end
end
