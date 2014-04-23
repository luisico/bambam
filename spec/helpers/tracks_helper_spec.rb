require "spec_helper"

describe TracksHelper do
  describe "#igv_url" do
    before { @track = FactoryGirl.create(:track) }

    it "needs a track object as argument" do
      expect{helper.igv_url}.to raise_error(ArgumentError)
    end

    it "points to a local igv instance" do
      expect(helper.igv_url(@track)).to match %r{^http://localhost:60151}
    end

    it "sets the path to 'load'" do
      path = URI(helper.igv_url(@track)).path
      expect(path).to eq '/load'
    end

    context "query parameters include" do
      it "file properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode stream_services_track_url(@track)
        expect(query).to match %r{file=#{encoded}}
      end

      it "name properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode @track.name
        expect(query).to match /name=#{encoded}/
      end

      it "genome properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode 'hg19'
        expect(query).to match /genome=#{encoded}/
      end

      it "merge properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode 'true'
        expect(query).to match /merge=#{encoded}/
      end
    end
  end

  describe "#link_to_igv" do
    before do
      @track = FactoryGirl.build(:track)
      allow(helper).to receive(:igv_url).and_return('myurl')
    end

    it "needs a track as argument" do
      expect{helper.link_to_igv}.to raise_error(ArgumentError)
    end

    it "returns a link tag" do
      expect(helper.link_to_igv(@track)).to match 'href="myurl"'
    end

    it "default text is 'IGV'" do
      expect(helper.link_to_igv(@track)).to match '>igv</a>'
    end

    it "accepts an optional text for the link" do
      expect(helper.link_to_igv(@track, 'mytext')).to match ">mytext</a>"
    end
  end
end
