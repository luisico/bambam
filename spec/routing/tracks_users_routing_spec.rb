require 'rails_helper'

RSpec.describe "TracksUsers" do
  describe "routes to" do
    it "the create and update actions" do
      assert_routing({ path: '/tracks_users', method: :post },      { controller: 'tracks_users', action: 'create' })
      assert_routing({ path: '/tracks_users/1', method: :patch},    { controller: 'tracks_users', action: 'update', id: '1'})
    end
  end
end
