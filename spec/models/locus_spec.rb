require 'rails_helper'

RSpec.describe Locus do
  before { @locus = FactoryGirl.build(:track_locus) }

  subject { @locus }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:locusable_id) }
    it { is_expected.to have_db_column(:locusable_type) }
    it { is_expected.to have_db_column(:range) }
  end

  describe "user_id" do
    it { is_expected.to belong_to :user }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :user_id }
  end

  describe "locusable_id" do
    it { is_expected.to belong_to :locusable }
    it { is_expected.to respond_to :locusable }
    it { is_expected.to respond_to :locusable_id }
  end

  describe "locusable_type" do
    it { is_expected.to respond_to :locusable_type }
  end

  describe "range" do
    it { is_expected.to respond_to :range }
  end
end
