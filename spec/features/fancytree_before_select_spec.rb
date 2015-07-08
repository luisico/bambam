require 'rails_helper'

RSpec.feature "Before select" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "manager cancels deselection of parent of selected track", js: true do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @manager)
    visit project_path(@project)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'

    expect {
      reject_confirm_from do
        select_node('datapath1')
      end
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
  end

  scenario "manager confirms deselection of parent of selected track", js: true do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @manager)
    visit project_path(@project)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'

    expect {
      accept_confirm_from do
        select_node('datapath1')
      end
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.projects_datapaths, :count).by(-1)

    expect(fancytree_parent(@datapaths[0].path)[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('track11')[:class]).not_to include 'fancytree-selected'
  end

  scenario "manager cancels selection of sibling folder of selected track", js: true do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    track11 = preselect_track(datapath1, 'track11', 'bam', @manager)
    track111 = preselect_track(datapath1, 'track111', 'bam', @manager)

    visit project_path(@project)
    [datapath1.path, 'track11', 'track111.bam'].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      reject_confirm_from do
        select_node('dir111')
      end
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)
    expect(@project.tracks.count).to eq 2

    [datapath1.path, 'track11', 'track111.bam'].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
    expect(fancytree_parent('dir111')[:class]).not_to include 'fancytree-selected'
  end

  scenario "manager confirms selection of sibling folder of selected track", js: true do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    track11 = preselect_track(datapath1, 'track11', 'bam', @manager)
    track111 = preselect_track(datapath1, 'track111', 'bam', @manager)

    visit project_path(@project)
    [datapath1.path, 'track11', 'track111.bam'].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      accept_confirm_from do
        select_node('dir111')
      end
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)
    expect(@project.tracks.count).to eq 0

    [datapath1.path, 'track11', 'track111.bam'].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'
  end
end
