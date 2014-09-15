require "spec_helper"

describe 'Search' do
  describe "routes to" do
    it "the search route" do
      assert_routing({ path: '/search', method: :post }, { controller: 'search' })
    end
  end
end
