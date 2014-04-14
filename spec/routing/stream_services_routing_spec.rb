require "spec_helper"

describe 'StreamServices' do
  describe "routes to" do
    it "stream" do
      assert_routing({ path: '/stream/:filename', method: :get }, { controller: 'stream_services', action: 'stream', filename: ':filename' })
    end
    it "stream including filename extension" do
      assert_routing({ path: '/stream/filename.ext', method: :get }, { controller: 'stream_services', action: 'stream', filename: 'filename.ext' })
    end
  end
end
