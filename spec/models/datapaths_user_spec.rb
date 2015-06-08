require 'rails_helper'

RSpec.describe DatapathsUser do
  before { @datapaths_user = FactoryGirl.build(:datapaths_user) }

  subject { @datapaths_user }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:datapath_id) }
  end

  describe "user_id" do
    it { is_expected.to belong_to :user }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :user_id }
  end

  describe "datapath_id" do
    it { is_expected.to belong_to :datapath }
    it { is_expected.to respond_to :datapath }
    it { is_expected.to respond_to :datapath_id }
  end

  describe "when datapaths_user is destroyed" do
    before do
      @datapaths_user = FactoryGirl.create(:datapaths_user)
    end

    it "should destroy the datapaths_user" do
      expect {
        @datapaths_user.destroy
      }.to change(DatapathsUser, :count).by(-1)
    end

    it "should destroy projects_datapath associated with the datapaths_user's user" do
      datapath = @datapaths_user.datapath
      manager = @datapaths_user.user
      project = FactoryGirl.create(:project, owner: manager)
      FactoryGirl.create(:projects_datapath, project: project, datapath: datapath)

      expect {
        @datapaths_user.destroy
      }.to change(ProjectsDatapath, :count).by(-1)
    end

    it "should not destroy other projects_datapaths" do
      FactoryGirl.create(:projects_datapath)

      expect {
        @datapaths_user.destroy
      }.not_to change(ProjectsDatapath, :count)
    end

    it "should destroy tracks associated with the datapths_user's user" do
      datapath = @datapaths_user.datapath
      manager = @datapaths_user.user
      project = FactoryGirl.create(:project, owner: manager)
      pd = FactoryGirl.create(:projects_datapath, project: project, datapath: datapath)
      FactoryGirl.create(:track, projects_datapath: pd)

      expect {
        @datapaths_user.destroy
      }.to change(Track, :count).by(-1)
    end

    it "should not destroy other tracks" do
      FactoryGirl.create(:track)

      expect {
        @datapaths_user.destroy
      }.not_to change(Track, :count)
    end
  end
end
