require "spec_helper"

describe "Datapaths" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/datapaths', method: :get },       { controller: 'datapaths', action: 'index' })
      assert_routing({ path: '/datapaths', method: :post },      { controller: 'datapaths', action: 'create' })
    end
  end
end
