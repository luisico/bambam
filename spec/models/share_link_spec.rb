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
    it { should validate_presence_of(:access_token) }
  end

  describe "expires_at" do
    it { should respond_to :expires_at }
    it { should validate_presence_of(:expires_at) }
  end

  describe "track_id" do
    it { should belong_to :track }
    it { should respond_to :track }
    it { should validate_presence_of(:track_id) }
  end

  describe "#expired?" do
    before { @share_link = FactoryGirl.create(:share_link) }

    it "returns false when not expired" do
      expect(@share_link.expired?).to eq false
    end

    it "returns true when expired" do
      @share_link.update_attribute(:expires_at, DateTime.yesterday)
      expect(@share_link.expired?).to eq true
    end
  end
end
