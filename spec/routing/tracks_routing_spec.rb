require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes" do
      assert_routing({ path: '/tracks', method: :get },{ controller: 'tracks', action: 'index' })
      assert_routing({ path: '/tracks/1', method: :get }, { controller: 'tracks', action: 'show', id: '1' })
      assert_routing({ path: '/tracks/new', method: :get }, { controller: 'tracks', action: 'new' })
      assert_routing({ path: '/tracks', method: :post },{ controller: 'tracks', action: 'create' })
      assert_routing({ path: '/tracks/1/edit', method: :get}, { controller: 'tracks', action: 'edit', id: '1' })
      assert_routing({ path: '/tracks/1', method: :patch}, { controller: 'tracks', action: 'update', id: '1'})
      assert_routing({ path: '/tracks/1', method: :delete}, { controller: 'tracks', action: 'destroy', id: '1'})
    end
  end
end
