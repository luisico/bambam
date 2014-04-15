require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes" do
      assert_routing({ path: '/tracks', method: :get },{ controller: 'tracks', action: 'index' })
      assert_routing({ path: '/tracks/1', method: :get }, { controller: 'tracks', action: 'show', id: '1' })
      assert_routing({ path: '/tracks/new', method: :get }, { controller: 'tracks', action: 'new' })
      assert_routing({ path: '/tracks', method: :post },{ controller: 'tracks', action: 'create' })
    end
  end
end
