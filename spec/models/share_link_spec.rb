require 'spec_helper'

describe ShareLink do
  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:access_token) }
    it { should have_db_column(:expires_at) }
    it { should have_db_column(:track_id) }
  end

  describe "access_token" do
    it { should respond_to :access_token }
  end

  describe "expires_at" do
    it { should respond_to :expires_at }
  end

  describe "track_id" do
    it { should belong_to :track }
    it { should respond_to :track }
  end

  describe ".build_share_link" do
    before { @track = FactoryGirl.create(:test_track) }

    context "with valid argument" do
      before { @share_link = ShareLink.build_share_link(@track) }

      it "has a the right length access token" do
        @share_link.access_token.length == 32
      end

      it "associates with the correct track" do
        @share_link.track = @track
      end

      it "expires at the correct time" do
        @share_link.expires_at = Time.now + 3.days
      end
    end
  end
end
