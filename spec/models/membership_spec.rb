require 'rails_helper'

RSpec.describe Membership do
  before { @membership = FactoryGirl.build(:membership) }

  subject { @membership }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:group_id) }
  end

  describe "user_id" do
    it { is_expected.to respond_to :user_id }
  end

  describe "group_id" do
    it { is_expected.to respond_to :group_id }
  end

  describe "associations" do
    context "users" do
      it { is_expected.to belong_to :user }
      it { is_expected.to respond_to :user }
      it { is_expected.to respond_to :user_id }
    end

    context "groups" do
      it { is_expected.to belong_to :group }
      it { is_expected.to respond_to :group }
      it { is_expected.to respond_to :group_id }
    end
  end
end
