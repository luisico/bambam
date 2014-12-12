FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| File.join("tmp", "tracks", "track#{n}.bam") }
    projects_datapath
    owner

    factory :test_track do
      sequence(:name) {|n| "track#{n}" }
      sequence(:path) {|n| File.join("tmp", "tests", "track#{n}.bam") }
    end

    after(:build) do |track|
      if track.project && track.project.projects_datapaths.empty?
        track_projects_datapath = FactoryGirl.create(:projects_datapath, project: track.project)
        track.project.projects_datapaths << track_projects_datapath
        track.projects_datapath = track_projects_datapath
      elsif track.project && (track.project != track.projects_datapath.project)
        track.projects_datapath = track.project.projects_datapaths.first
      else
        track.project = Project.find(track.projects_datapath.project_id)
      end

      unless File.exist?(track.path)
        Pathname.new(track.path).dirname.mkpath
        FileUtils.cp File.join(Rails.root, 'spec', 'data', 'tracks', 'test_500_sorted.bam'), track.path
      end
    end
  end
end
