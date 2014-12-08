require "spec_helper"

describe "Datapaths" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/datapaths', method: :get },       { controller: 'datapaths', action: 'index' })
      assert_routing({ path: '/datapaths/new', method: :get },   { controller: 'datapaths', action: 'new' })
      assert_routing({ path: '/datapaths', method: :post },      { controller: 'datapaths', action: 'create' })
      assert_routing({ path: '/datapaths/1', method: :delete},   { controller: 'datapaths', action: 'destroy', id: '1'})
    end
  end
end
