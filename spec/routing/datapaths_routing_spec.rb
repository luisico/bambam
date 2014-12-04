require "spec_helper"

describe "Datapaths" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/datapaths', method: :get },       { controller: 'datapaths', action: 'index' })
    end
  end
end
