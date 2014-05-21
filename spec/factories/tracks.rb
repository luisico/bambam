FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| File.join("tmp", "tracks", "track#{n}") }

    factory :test_track do
      sequence(:name) {|n| "track#{n}" }
      sequence(:path) {|n| File.join("tmp", "tests", "track#{n}.bam") }
    end

    after(:build) do |track|
      unless File.exist?(track.path)
        Pathname.new(track.path).dirname.mkpath
        File.open(track.path, 'w'){|f| f.puts track.name}
      end
    end
  end
end
