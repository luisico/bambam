require 'rails_helper'

RSpec.describe 'StreamServices' do
  describe "routes to" do
    it "stream" do
      assert_routing({ path: '/stream/track/1',         method: :get }, { controller: 'stream_services', action: 'show', id: '1' })
      assert_routing({ path: '/stream/track/1.bam',     method: :get }, { controller: 'stream_services', action: 'show', id: '1', format: 'bam' })
      assert_routing({ path: '/stream/track/1.bai',     method: :get }, { controller: 'stream_services', action: 'show', id: '1', format: 'bai' })
      assert_routing({ path: '/stream/track/1.bam.bai', method: :get }, { controller: 'stream_services', action: 'show', id: '1', format: 'bam.bai' })
    end
  end
end
