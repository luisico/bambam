require 'rails_helper'

RSpec.describe "Groups" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/groups/1', method: :get },     { controller: 'groups', action: 'show', id: '1' })
      assert_routing({ path: '/groups/new', method: :get },   { controller: 'groups', action: 'new' })
      assert_routing({ path: '/groups', method: :post },      { controller: 'groups', action: 'create' })
      assert_routing({ path: '/groups/1/edit', method: :get}, { controller: 'groups', action: 'edit', id: '1' })
      assert_routing({ path: '/groups/1', method: :patch},    { controller: 'groups', action: 'update', id: '1'})
      assert_routing({ path: '/groups/1', method: :delete},   { controller: 'groups', action: 'destroy', id: '1'})
    end
  end
end
