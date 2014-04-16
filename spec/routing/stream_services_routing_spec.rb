require "spec_helper"

describe 'StreamServices' do
  describe "routes to" do
    it "stream" do
      assert_routing({ path: '/stream/track/1', method: :get }, { controller: 'stream_services', action: 'show', id: '1' })
    end
  end
end
