FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| File.join("tmp", "tracks", "track#{n}.bam") }
    genome "hg19"
    project

    factory :test_track do
      sequence(:name) {|n| "track#{n}" }
      sequence(:path) {|n| File.join("tmp", "tests", "track#{n}.bam") }
    end

    after(:build) do |track|
      unless File.exist?(track.path)
        Pathname.new(track.path).dirname.mkpath
        FileUtils.cp File.join(Rails.root, 'spec', 'data', 'tracks', 'test_500_sorted.bam'), track.path
      end
    end
  end
end
