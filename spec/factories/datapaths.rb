# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :datapath do
    sequence(:path) {|n| File.join("tmp", "tests", "datapath#{n}") }

    factory :seeded_datapath do
      sequence(:path) {|n| File.join("tmp", "datapaths", "datapath#{n}") }
    end

    after(:build) do |datapath|
      Pathname.new(datapath.path).mkpath unless File.exist?(datapath.path)
    end
  end
end
