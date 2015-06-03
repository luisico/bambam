require 'rails_helper'

RSpec.describe "Projects" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/projects', method: :get },       { controller: 'projects', action: 'index' })
      assert_routing({ path: '/projects/1', method: :get },     { controller: 'projects', action: 'show', id: '1' })
      assert_routing({ path: '/projects/new', method: :get },   { controller: 'projects', action: 'new' })
      assert_routing({ path: '/projects', method: :post },      { controller: 'projects', action: 'create' })
      assert_routing({ path: '/projects/1/edit', method: :get}, { controller: 'projects', action: 'edit', id: '1' })
      assert_routing({ path: '/projects/1', method: :patch},    { controller: 'projects', action: 'update', id: '1'})
      assert_routing({ path: '/projects/1', method: :delete},   { controller: 'projects', action: 'destroy', id: '1'})
    end
  end
end

