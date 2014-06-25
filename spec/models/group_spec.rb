require 'spec_helper'

describe Group do
  before { @group = FactoryGirl.build(:group) }

  subject { @group }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:name) }
    it { should have_db_column(:owner_id) }
  end

  describe "name" do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
  end

  describe "owners" do
    it { should belong_to :owner }
    it { should respond_to :owner }
  end

  describe "memberships" do
    it { should have_many :memberships }
    it { should respond_to :memberships }
    it { should respond_to :membership_ids }
  end

  describe "members" do
    it { should have_many :members }
    it { should respond_to :members }
    it { should respond_to :member_ids }
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
