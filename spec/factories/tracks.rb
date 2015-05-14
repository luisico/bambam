FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| File.join("tracks", "track#{n}.bam") }
    genome "hg19"
    projects_datapath
    owner

    after(:build) do |track|
      unless File.exist?(track.full_path)
        Pathname.new(track.full_path).dirname.mkpath
        FileUtils.cp File.join(Rails.root, 'spec', 'data', 'tracks', 'test_500_sorted.bam'), track.full_path
      end
    end
  end
end
