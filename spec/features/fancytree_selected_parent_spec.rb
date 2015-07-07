require 'rails_helper'

RSpec.feature "Selected parent" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "manager creates orphan tracks", js: true do
    projects_datapath = preselect_datapath(@project, @datapaths[0])
    %w[track1111 track1112 track1211 track1212].each do |name|
      preselect_track(projects_datapath, name, 'bam', @manager)
    end

    visit project_path(@project)
    [@datapaths[0].path] + %w[track1111.bam track1112.bam track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(1)
    expect(@project.tracks.count).to eq 4

    expect(fancytree_parent(@datapaths[0].path)[:class]).not_to include 'fancytree-selected'
    %w[dir111 track1111.bam track1112.bam dir121 track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "manager selects child of selected datapath", js: true do
    preselect_datapath(@project, @datapaths[0], 'dir11')
    visit project_path(@project)
    expect(fancytree_parent('dir11')[:class]).to include 'fancytree-selected'

    expect {
      expand_node('dir11')
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('dir11')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'
  end

  scenario "manager selects child of selected datapath with tracks", js: true do
    dir11 = preselect_datapath(@project, @datapaths[0], 'dir11')
    %w[track1111 track1112].each do |name|
      preselect_track(dir11, name, 'bam', @manager)
    end

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq dir11
    end

    visit project_path(@project)
    %w[dir11 track1111.bam track1112.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    @project.tracks.each do |track|
      expect(track.projects_datapath).not_to eq dir11
    end

    expect(fancytree_parent("dir11")[:class]).not_to include 'fancytree-selected'
    ['dir111', "track1111.bam", "track1112.bam"].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "manager selects sibling folder of selected track", js: true do
    dir11 = preselect_datapath(@project, @datapaths[0], 'dir11')
    track111 = preselect_track(dir11, 'track111', 'bam', @manager)

    visit project_path(@project)
    %w[dir11 track111.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)
    expect(@project.tracks.count).to eq 0

    %w[dir11 track111.bam].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'
  end

  scenario "selecting sibling of tack hides checkbox on track", js: true do
    preselect_datapath(@project, @datapaths[0])

    visit project_path(@project)
    expand_node(@datapaths[0].path)
    expand_node('dir11')
    expect(fancytree_parent('track111.bam')).to have_css '.fancytree-checkbox'

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('track111.bam')).not_to have_css '.fancytree-checkbox'
  end
end
