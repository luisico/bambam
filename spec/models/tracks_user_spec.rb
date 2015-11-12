require 'rails_helper'

RSpec.describe TracksUser do
  before { @tracks_user = FactoryGirl.build(:tracks_user) }

  subject { @tracks_user }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:track_id) }
    it { is_expected.to have_db_column(:locus) }
  end

  describe "user_id" do
    it { is_expected.to belong_to :user }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :user_id }
  end

  describe "track_id" do
    it { is_expected.to belong_to :track }
    it { is_expected.to respond_to :track }
    it { is_expected.to respond_to :track_id }
  end
end
