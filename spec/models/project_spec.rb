require 'spec_helper'

describe Project do
  before { @project = FactoryGirl.build(:project) }

  subject { @project }

  describe "database fields" do
    it { is_expected.to have_db_column(:name).with_options(null: false) }
    it { is_expected.to have_db_index(:name).unique(false) }
    it { is_expected.to have_db_column(:owner_id).with_options(null: false) }
  end

  describe "name" do
    it { is_expected.to respond_to :name }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "owner" do
    it { is_expected.to belong_to :owner }
    it { is_expected.to respond_to :owner }
    it { is_expected.to respond_to :owner_id }
    it { is_expected.to validate_presence_of(:owner_id) }
  end

  describe "projects_users" do
    it { is_expected.to have_many :projects_users }
    it { is_expected.to respond_to :projects_users }
    it { is_expected.to respond_to :projects_user_ids }
  end

  describe "users" do
    it { is_expected.to have_many :users }
    it { is_expected.to respond_to :users }
    it { is_expected.to respond_to :user_ids }
    it "should not include owner" do
      @project.save!
      expect(@project.users).not_to include(@project.owner)
    end
  end

  describe "projects_datapaths" do
    it { is_expected.to have_many :projects_datapaths }
    it { is_expected.to respond_to :projects_datapaths }
    it { is_expected.to respond_to :projects_datapath_ids }
  end

  describe "datapaths" do
    it { is_expected.to have_many(:datapaths).through(:projects_datapaths) }
    it { is_expected.to respond_to :datapaths }
    it { is_expected.to respond_to :datapath_ids }
  end

  describe "tracks" do
    it { is_expected.to have_many(:tracks).through(:projects_datapaths) }
    it { is_expected.to respond_to :tracks }
    it { is_expected.to respond_to :track_ids }
  end

  describe "#allowed_datapaths" do
    it "should return an array of allowed datapaths for the project" do
      datapath1 = FactoryGirl.create(:datapath)
      datapath2 = FactoryGirl.create(:datapath)

      FactoryGirl.create(:projects_datapath, project: @project, datapath: datapath1, sub_directory: "mysubdir")
      FactoryGirl.create(:projects_datapath, project: @project, datapath: datapath1, sub_directory: "")
      FactoryGirl.create(:projects_datapath, project: @project, datapath: datapath2, sub_directory: "")

      expect(@project.allowed_paths).to eq [
        File.join(datapath1.path, "mysubdir"),
        datapath1.path,
        datapath2.path
      ]
    end

    it "should return an empty array when the project has no datapaths" do
      expect(@project.allowed_paths).to eq []
    end
  end

  describe "project user permissions" do
    before do
      @project.users << @users = FactoryGirl.create_list(:user, 2)
      @read_only_users = FactoryGirl.create_list(:user, 2, projects: [@project])
      @read_only_users.each {|u| u.projects_users.first.update_attributes(read_only: true)}
    end

    context "#regular_users" do
      it "returns all regular users" do
        expect(@project.regular_users).to eq @users
      end
    end

    context "#read_only_users" do
      it "returns all read-only users" do
        expect(@project.read_only_users).to eq @read_only_users
      end
    end
  end

  describe "when project destroyed" do
    before do
      @project.users << FactoryGirl.create(:user)
      @project.save!
    end

    it "should destroy the project" do
      expect { @project.destroy }.to change(Project, :count).by(-1)
      expect { Project.find(@project.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy associated memberships" do
      expect { @project.destroy }.to change(ProjectsUser, :count).by(-1)
    end

    it "should not destroy the user" do
      expect { @project.destroy }.not_to change(User, :count)
    end
  end
end
