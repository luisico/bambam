require 'rails_helper'

RSpec.describe "Loci" do
  describe "routes to" do
    it "the create and update actions" do
      assert_routing({ path: '/loci/1', method: :patch},    { controller: 'loci', action: 'update', id: '1'})
    end
  end
end
