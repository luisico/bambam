require "spec_helper"

describe PagesController do
  describe "routing" do
    it "routes" do
      assert_routing({ path: '/tracks', method: :get },{ controller: 'tracks', action: 'index' })
      assert_routing({ path: '/tracks/1', method: :get }, { controller: 'tracks', action: 'show', id: '1' })
    end
  end
end
