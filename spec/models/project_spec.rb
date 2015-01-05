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
    it { should validate_presence_of(:name) }
  end

  describe "owner" do
    it { should belong_to :owner }
    it { should respond_to :owner }
  end

  describe "projects_users" do
    it { should have_many :projects_users }
    it { should respond_to :projects_users }
    it { should respond_to :projects_user_ids }
  end

  describe "users" do
    it { should have_many :users }
    it { should respond_to :users }
    it { should respond_to :user_ids }
  end

  describe "projects_datapaths" do
    it { should have_many :projects_datapaths }
    it { should respond_to :projects_datapaths }
    it { should respond_to :projects_datapath_ids }
  end

  describe "datapaths" do
    it { should have_many(:datapaths).through(:projects_datapaths) }
    it { should respond_to :datapaths }
    it { should respond_to :datapath_ids }
  end

  describe "tracks" do
    it { should have_many(:tracks).through(:projects_datapaths) }
    it { should respond_to :tracks }
    it { should respond_to :track_ids }
  end

  describe "#allowed_datapaths" do
    it "should return an array of allowed datapaths for the project" do
      master1 = FactoryGirl.create(:datapath)
      master2 = FactoryGirl.create(:datapath)

      FactoryGirl.create(:projects_datapath, project: @project, datapath: master1, sub_directory: "mysubdir")
      FactoryGirl.create(:projects_datapath, project: @project, datapath: master1, sub_directory: "")
      FactoryGirl.create(:projects_datapath, project: @project, datapath: master2, sub_directory: "")

      expect(@project.allowed_paths).to eq [
        File.join(master1.path, "mysubdir"),
        master1.path,
        master2.path
      ]
    end

    it "should return an empty array when the project has no datapaths" do
      expect(@project.allowed_paths).to eq []
    end
  end

  describe "project user permissions" do
    before do
      @project.users << @user = FactoryGirl.create(:user)
      @regular_users = [@project.owner, @user]
      @read_only_users = FactoryGirl.create_list(:user, 2, projects: [@project])
      @read_only_users.each {|u| u.projects_users.first.update_attributes(read_only: true)}
    end

    context "#regular_users" do
      it "returns all regular users" do
        expect(@project.regular_users).to eq @regular_users
      end
    end

    context "#read_only_users" do
      it "returns all read-only users" do
        expect(@project.read_only_users).to eq @read_only_users
      end
    end
  end

  describe "when project destroyed" do
    before {@project.save!}

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
