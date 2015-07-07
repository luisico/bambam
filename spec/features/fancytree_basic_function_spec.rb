require 'rails_helper'

RSpec.feature "Selected child folders" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "manager adds a top level datapath", js: true do
    visit project_path(@project)

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.projects_datapaths, :count).by(1)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "manager adds a nested datapath", js: true do
    visit project_path(@project)

    expect {
      expand_node(@datapaths[0].path)
      select_node('dir11')
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.projects_datapaths, :count).by(1)

    expect(fancytree_parent('dir11')[:class]).to include 'fancytree-selected'
  end

  scenario "manager adds a track to a top level datapath", js: true do
    visit project_path(@project)
    select_node(@datapaths[0].path)
    loop until page.evaluate_script('jQuery.active').zero?

    expect {
      expand_node(@datapaths[0].path)
      select_node('track11.bam')
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.tracks, :count).by(1)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
  end

  scenario "manager adds a track to a nested datapath", js: true do
    visit project_path(@project)
    expand_node(@datapaths[0].path)
    select_node('dir11')
    loop until page.evaluate_script('jQuery.active').zero?

    expect {
      expand_node('dir11')
      select_node('track111.bam')
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.tracks, :count).by(1)

    expect(fancytree_parent('track111')[:class]).to include 'fancytree-selected'
  end
end
