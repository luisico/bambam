FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| File.join "", "zenodotus", "track#{n}"}
  end
end
