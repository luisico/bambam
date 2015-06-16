require 'rails_helper'

RSpec.feature "fancytree" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths
    add_user_to_datapaths(@manager, @datapaths)
    preselect_datapath(@project, @datapaths[0], 'subdir1')
  end

  scenario "Manager views selected datapath on project page", js: true do
    sign_in @manager
    visit project_path(@project)
    expect(page).to have_text 'subdir1'
  end
end
