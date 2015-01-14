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
    it "should touch the project" do
      expect {
        @projects_datapath.save
      }.to change(@projects_datapath.project, :updated_at)
    end
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
      expect(@projects_datapath.full_path).to eq File.join(
        @projects_datapath.datapath.path,
        @projects_datapath.sub_directory
      )
    end

    it "should return the full path of the projects datapath with empty sub_directory" do
      ["", nil].each do |empty|
        @projects_datapath.sub_directory = empty
        expect(@projects_datapath.full_path).to eq File.join(
          @projects_datapath.datapath.path
        )
      end
    end
  end
end
