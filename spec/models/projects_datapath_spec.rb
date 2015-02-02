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

  describe "#remove_nil" do
    context "sub_directory" do
      it "is set to a empty string when nil" do
          @projects_datapath.sub_directory = nil
          expect {
            @projects_datapath.save
            @projects_datapath.reload
          }.to change(@projects_datapath, :sub_directory).to('')
      end

      it "is not changed when not nil" do
         @projects_datapath.sub_directory = 'dir1'
        expect {
          @projects_datapath.save
          @projects_datapath.reload
        }.not_to change(@projects_datapath, :sub_directory)
      end
    end
  end

  describe "validations" do
    context "#datapath_id_exists" do
      before do
        datapath = FactoryGirl.create(:datapath)
        @invalid_projects_datapath = FactoryGirl.build(:projects_datapath, datapath: datapath)
        datapath.destroy
      end

      it "should require a valid datapath" do
        expect(@invalid_projects_datapath).not_to be_valid
      end

      it "should add datapath_id errors to error messages" do
        @invalid_projects_datapath.valid?
        expect(@invalid_projects_datapath.errors[:datapath_id]).to be_present
      end
    end
  end
end
