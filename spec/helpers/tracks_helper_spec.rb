require 'rails_helper'

RSpec.describe TracksHelper do
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

    context "query parameter" do
      it "file is properly encoded and includes extension" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode stream_services_track_url(@track, format: 'bam')
        expect(query).to match %r{file=#{encoded}}
      end

      it "name is properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode @track.name
        expect(query).to match /name=#{encoded}/
      end

      it "genome is properly encoded" do
        query = URI(helper.igv_url(@track)).query
        encoded = ERB::Util.url_encode @track.genome
        expect(query).to match /genome=#{encoded}/
      end

      it "merge is properly encoded" do
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
      expect(helper.link_to_igv(@track)).to match '>igv<span'
    end

    it "accepts an optional text for the link" do
      expect(helper.link_to_igv(@track, 'mytext')).to match ">mytext<span"
    end

    it "contains a zurb foundation tooltip" do
      expect(helper.link_to_igv(@track)).to match "<span data-tooltip"
    end
  end

  describe "#ucsc_url" do
    before do
      @track = FactoryGirl.create(:track)
      @share_link = FactoryGirl.create(:share_link, track: @track)
    end

    it "needs a share_link as argument" do
      expect{helper.ucsc_url}.to raise_error(ArgumentError)
    end

    it "points to the track's stream service" do
      url = helper.ucsc_url(@share_link)
      url_with_access_token = url.sub("?access_token=#{@share_link.access_token}",'')
      expect(url_with_access_token).to eq stream_services_track_url(@track)
    end

    it "access_token is encoded" do
      uri = URI(helper.ucsc_url(@share_link))
      expect(uri.query).to eq "access_token=#{@share_link.access_token}"
    end
  end

  describe "#ucsc_track_line" do
    before do
      @track = FactoryGirl.create(:track)
      @share_link = FactoryGirl.create(:share_link, track: @track)
      allow(helper).to receive(:ucsc_url).and_return('myurl')
    end

    it "needs a track as argument" do
      expect{helper.ucsc_track_line}.to raise_error(ArgumentError)
    end

    it "starts with the word 'track'" do
      expect(helper.ucsc_track_line(@share_link)).to match /^track /
    end

    context "track type" do
      it "for bam files" do
        @track.path << '.bam'
        expect(helper.ucsc_track_line(@share_link)).to match /type=bam/
      end

      it "for bigwig files" do
        @track.path << '.bw'
        expect(helper.ucsc_track_line(@share_link)).to match /type=bigWig/
      end

      it "is not included when unkown" do
        @track.path << '.unk'
        expect(helper.ucsc_track_line(@share_link)).not_to include 'type='
      end
    end

    context "track name" do
      it "is included when known" do
        expect(helper.ucsc_track_line(@share_link)).to match /name="#{@track.name}"/
      end

      it "is not included when empty" do
        @track.name = ''
        expect(helper.ucsc_track_line(@share_link)).not_to include 'name='
      end

      it "is not included when nil" do
        @track.name = nil
        expect(helper.ucsc_track_line(@share_link)).not_to include 'name='
      end
    end

    context "track url" do
      it "points the track's stream service" do
        expect(helper.ucsc_track_line(@share_link)).to match /bigDataUrl=myurl/
      end
    end
  end
end
