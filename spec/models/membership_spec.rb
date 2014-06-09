require 'spec_helper'

describe Membership do
  before { @membership = FactoryGirl.build(:membership) }

  subject { @membership }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:user_id) }
    it { should have_db_column(:group_id) }
  end

  describe "user_id" do
    it { should respond_to :user_id }
  end

  describe "group_id" do
    it { should respond_to :group_id }
  end

  describe "associations" do
    context "users" do
      it { should belong_to :user }
      it { should respond_to :user }
      it { should respond_to :user_id }
    end

    context "groups" do
      it { should belong_to :group }
      it { should respond_to :group }
      it { should respond_to :group_id }
    end
  end
end
