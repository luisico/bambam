require 'rails_helper'

RSpec.describe "ProjectsDatapaths" do
  describe "routes to" do
    it "the index and show actions" do
      assert_routing({ path: '/projects_datapaths', method: :post },       { controller: 'projects_datapaths', action: 'create' })
      assert_routing({ path: '/projects_datapaths/browser', method: :get}, { controller: 'projects_datapaths', action: 'browser'})
      assert_routing({ path: '/projects_datapaths/1', method: :delete},    { controller: 'projects_datapaths', action: 'destroy', id: '1'})
    end
  end
end
