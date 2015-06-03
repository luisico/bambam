require 'rails_helper'

RSpec.describe "Datapaths" do
  describe "routes to" do
    it "all restful actions except show" do
      assert_routing({ path: '/datapaths', method: :get },        { controller: 'datapaths', action: 'index' })
      assert_routing({ path: '/datapaths/new', method: :get },    { controller: 'datapaths', action: 'new' })
      assert_routing({ path: '/datapaths/1/edit', method: :get},  { controller: 'datapaths', action: 'edit', id: '1' })
      assert_routing({ path: '/datapaths', method: :post },       { controller: 'datapaths', action: 'create' })
      assert_routing({ path: '/datapaths/1', method: :patch},     { controller: 'datapaths', action: 'update', id: '1'})
      assert_routing({ path: '/datapaths/1', method: :delete},    { controller: 'datapaths', action: 'destroy', id: '1'})
    end
  end
end
