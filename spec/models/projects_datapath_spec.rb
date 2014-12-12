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

  describe "tracks" do
    it { should have_many :tracks }
    it { should respond_to :tracks }
    it { should respond_to :track_ids }
  end

  describe "#full_path" do
    it "should return the full path of the projects datapath" do
      result = File.join(
                          Datapath.find(@projects_datapath.datapath_id).path,
                          @projects_datapath.sub_directory
                        )

      expect(@projects_datapath.full_path).to eq result
    end

    it "should return the full path of the projects datapath with empty sub_directory" do
      @projects_datapath.sub_directory = ""
      result = File.join(Datapath.find(@projects_datapath.datapath_id).path)

      expect(@projects_datapath.full_path).to eq result
    end
  end
end
