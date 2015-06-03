require 'rails_helper'

RSpec.describe ProjectsUser do
  before { @projects_user = FactoryGirl.build(:projects_user) }

  subject { @projects_user }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:project_id) }
    it { is_expected.to have_db_column(:read_only) }
  end

  describe "user_id" do
    it { is_expected.to belong_to :user }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :user_id }
  end

  describe "project_id" do
    it { is_expected.to belong_to :project }
    it { is_expected.to respond_to :project }
    it { is_expected.to respond_to :project_id }
  end
end
