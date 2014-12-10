require 'spec_helper'

describe DatapathsUser do
  before { @datapaths_user = FactoryGirl.build(:datapaths_user) }

  subject { @datapaths_user }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:user_id) }
    it { should have_db_column(:datapath_id) }
  end

  describe "user_id" do
    it { should belong_to :user }
    it { should respond_to :user }
    it { should respond_to :user_id }
  end

  describe "datapath_id" do
    it { should belong_to :datapath }
    it { should respond_to :datapath }
    it { should respond_to :datapath_id }
  end
end
