require 'rails_helper'

RSpec.describe Group do
  before { @group = FactoryGirl.build(:group) }

  subject { @group }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:owner_id) }
  end

  describe "name" do
    it { is_expected.to respond_to :name }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "owners" do
    it { is_expected.to belong_to :owner }
    it { is_expected.to respond_to :owner }
  end

  describe "memberships" do
    it { is_expected.to have_many :memberships }
    it { is_expected.to respond_to :memberships }
    it { is_expected.to respond_to :membership_ids }
  end

  describe "members" do
    it { is_expected.to have_many :members }
    it { is_expected.to respond_to :members }
    it { is_expected.to respond_to :member_ids }
  end

  describe "when group destroyed" do
    before { @group.save! }

    it "should destroy the group" do
      expect { @group.destroy }.to change(Group, :count).by(-1)
      expect { Group.find(@group.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy associated memberships" do
      expect { @group.destroy }.to change(Membership, :count).by(-1)
    end

    it "should not destroy the owner or members" do
      expect { @group.destroy }.not_to change(User, :count)
    end
  end
end
