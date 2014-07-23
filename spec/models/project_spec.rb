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

  describe "tracks" do
    it { should have_many :tracks }
    it { should respond_to :tracks }
    it { should respond_to :track_ids }
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
