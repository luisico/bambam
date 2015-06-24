require 'rails_helper'

RSpec.feature "One datapath per file hierarchy" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "manager selects parent of selected datapath", js: true do
    preselect_datapath(@project, @datapaths[0], 'dir111')
    visit project_path(@project)
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('dir111')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "manager selects parent of selected datapath with tracks", js: true do
    dir111 = preselect_datapath(@project, @datapaths[0], 'dir111')
    %w[track1111 track1112].each do |name|
      preselect_track(dir111, name, 'bam', @manager)
    end

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq dir111
    end

    visit project_path(@project)
    %w[dir111 track1111.bam track1112.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    @project.tracks.each do |track|
      expect(track.projects_datapath).not_to eq dir111
    end

    expect(fancytree_parent("dir111")[:class]).not_to include 'fancytree-selected'
    [@datapaths[0].path, "track1111.bam", "track1112.bam"].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "manager selects parent of two selected datapaths", js: true do
    preselect_datapath(@project, @datapaths[0], 'dir111')
    preselect_datapath(@project, @datapaths[0], 'dir121')

    visit project_path(@project)
    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "manager selects parent of two selected datapaths with tracks", js: true do
    dir111 = preselect_datapath(@project, @datapaths[0], 'dir111')
    %w[track1111 track1112].each do |name|
      preselect_track(dir111, name, 'bam', @manager)
    end

    dir121 = preselect_datapath(@project, @datapaths[0], 'dir121')
    %w[track1211 track1212].each do |name|
      preselect_track(dir121, name, 'bam', @manager)
    end

    visit project_path(@project)
    %w[dir111 track1111.bam track1112.bam dir121 track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq ProjectsDatapath.last
    end

    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end

    [@datapaths[0].path] + %w[track1111.bam track1112.bam track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
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

  scenario "manager selects sibling folder of selected track", js: true do
    dir211 = preselect_datapath(@project, @datapaths[1], 'dir211')
    track2111 = preselect_track(dir211, 'track2111', 'bam', @manager)

    visit project_path(@project)
    %w[dir211 track2111.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node('dir2111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)
    expect(@project.tracks.count).to eq 0

    %w[dir211 track2111.bam].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent('dir2111')[:class]).to include 'fancytree-selected'
  end
end
