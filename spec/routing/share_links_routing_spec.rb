require "spec_helper"

describe "ShareLinks" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/share_links/new', method: :get },   { controller: 'share_links', action: 'new' })
      assert_routing({ path: '/share_links', method: :post },      { controller: 'share_links', action: 'create' })
      assert_routing({ path: '/share_links/1/edit', method: :get}, { controller: 'share_links', action: 'edit', id: '1' })
      assert_routing({ path: '/share_links/1', method: :patch},    { controller: 'share_links', action: 'update', id: '1'})
      assert_routing({ path: '/share_links/1', method: :delete},   { controller: 'share_links', action: 'destroy', id: '1'})
    end
  end
end
