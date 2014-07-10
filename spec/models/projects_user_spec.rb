require 'spec_helper'

describe ProjectsUser do
  before { @projects_user = FactoryGirl.build(:projects_user) }

  subject { @projects_user }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:user_id) }
    it { should have_db_column(:project_id) }
  end

  describe "user_id" do
    it { should belong_to :user }
    it { should respond_to :user }
    it { should respond_to :user_id }
  end

  describe "project_id" do
    it { should belong_to :project }
    it { should respond_to :project }
    it { should respond_to :project_id }
  end
end
