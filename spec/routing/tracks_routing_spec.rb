require "spec_helper"

describe "Tracks" do
  describe "routes to" do
    it "the index and show actions" do
      assert_routing({ path: '/tracks', method: :get },        { controller: 'tracks', action: 'index' })
      assert_routing({ path: '/tracks/1', method: :get },      { controller: 'tracks', action: 'show', id: '1' })
      assert_routing({ path: '/tracks', method: :post },       { controller: 'tracks', action: 'create' })

    end
  end
end
