# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :datapath do
    sequence(:path) {|n| File.join("tmp", "datapaths", "datapath#{n}") }

    factory :test_datapath do
      sequence(:path) {|n| File.join("tmp", "tests", "datapath#{n}") }
    end

    after(:build) do |datapath|
      unless File.exist?(datapath.path)
        Pathname.new(datapath.path).mkpath
      end
    end
  end
end
