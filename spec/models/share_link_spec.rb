require 'spec_helper'

describe ShareLink do
  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:access_token) }
    it { should have_db_column(:expires_at) }
    it { should have_db_column(:track_id) }
    it { should have_db_column(:notes) }
  end

  describe "access_token" do
    it { should respond_to :access_token }
    it { should validate_presence_of(:access_token) }
  end

  describe "expires_at" do
    it { should respond_to :expires_at }
  end

  describe "track_id" do
    it { should belong_to :track }
    it { should respond_to :track }
    it { should validate_presence_of(:track_id) }
  end

  describe "notes" do
    it { should respond_to :notes }
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

  describe "#expires_at_cannot_be_in_the_past" do
    before { @share_link = FactoryGirl.build(:share_link, expires_at: DateTime.yesterday) }

    it "should require a valid expires_at date" do
      expect(@share_link).not_to be_valid
    end

    it "should add expires_at errors to error messages" do
      @share_link.valid?
      expect(@share_link.errors[:expires_at]).to be_present
    end
  end

  describe "#default_values" do
    before { @share_link = FactoryGirl.build(:share_link) }

    it "sets notes equal to 'no notes'" do
      @share_link.notes = ""
      @share_link.save
      expect(@share_link.notes).to eq 'no notes'
    end

    it "sets expires_at equal to in 2 weeks" do
      @share_link.expires_at = ""
      @share_link.save
      expect(@share_link.expires_at.strftime('%d, %B %Y')).to eq (DateTime.now + 2.weeks).strftime('%d, %B %Y')
    end
  end
end
