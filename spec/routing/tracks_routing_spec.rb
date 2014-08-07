require "spec_helper"

describe "Tracks" do
  describe "routes to" do
    it "a complete set of restful actions" do
      assert_routing({ path: '/tracks', method: :get },        { controller: 'tracks', action: 'index' })
      assert_routing({ path: '/tracks/1', method: :get },      { controller: 'tracks', action: 'show', id: '1' })
      assert_routing({ path: '/tracks/1/share', method: :patch}, { controller: 'tracks', action: 'share', id: '1' })
    end
  end
end
