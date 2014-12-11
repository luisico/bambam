require 'spec_helper'

describe ProjectsDatapath do
  before { @projects_datapath = FactoryGirl.build(:projects_datapath) }

  subject { @projects_datapath }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:project_id) }
    it { should have_db_column(:datapath_id) }
    it { should have_db_column(:sub_directory) }
    it { should have_db_column(:name) }
  end

  describe "project_id" do
    it { should belong_to :project }
    it { should respond_to :project }
    it { should respond_to :project_id }
  end

  describe "datapath_id" do
    it { should belong_to :datapath }
    it { should respond_to :datapath }
    it { should respond_to :datapath_id }
  end

  describe "sub_directory" do
    it { should respond_to :sub_directory }
  end

  describe "name" do
    it { should respond_to :name }
  end
end
