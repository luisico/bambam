require 'spec_helper'

describe Project do
  before { @project = FactoryGirl.build(:project) }

  subject { @project }

  describe "database fields" do
    it { should have_db_column(:name).with_options(null: false) }
    it { should have_db_index(:name).unique(false) }
    it { should have_db_column(:owner_id) }
  end

  describe "name" do
    it { should respond_to :name }
  end

  describe "owner" do
    it { should respond_to :owner }
  end
end
