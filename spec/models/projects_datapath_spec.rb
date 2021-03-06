require 'rails_helper'

RSpec.describe ProjectsDatapath do
  before { @projects_datapath = FactoryGirl.build(:projects_datapath) }

  subject { @projects_datapath }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:project_id) }
    it { is_expected.to have_db_column(:datapath_id) }
    it { is_expected.to have_db_column(:path).with_options(null: false) }
    it { is_expected.to have_db_column(:name) }
  end

  describe "project_id" do
    it { is_expected.to belong_to :project }
    it { is_expected.to respond_to :project }
    it { is_expected.to respond_to :project_id }
    it "should touch the project" do
      expect {
        @projects_datapath.save
      }.to change(@projects_datapath.project, :updated_at)
    end
  end

  describe "datapath_id" do
    it { is_expected.to belong_to :datapath }
    it { is_expected.to respond_to :datapath }
    it { is_expected.to respond_to :datapath_id }
  end

  describe "path" do
    it { is_expected.to respond_to :path }
    it { is_expected.to validate_exclusion_of(:path).in_array([nil]) }

    it "should be invalid when nil" do
      @projects_datapath.path = nil
      expect(@projects_datapath).not_to be_valid
    end

    it "should be valid when an empty string" do
      @projects_datapath.path = ''
      expect(@projects_datapath).to be_valid
    end
  end

  describe "name" do
    it { is_expected.to respond_to :name }
  end

  describe "tracks" do
    it { is_expected.to have_many :tracks }
    it { is_expected.to respond_to :tracks }
    it { is_expected.to respond_to :track_ids }
  end

  describe "#full_path" do
    it "should return the full path of the projects datapath" do
      expect(@projects_datapath.full_path).to eq File.join(
        @projects_datapath.datapath.path,
        @projects_datapath.path
      )
    end

    it "should return the full path of the projects datapath with empty path" do
      ["", nil].each do |value|
        @projects_datapath.path = value
        expect(@projects_datapath.full_path).to eq File.join(
          @projects_datapath.datapath.path
        )
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
