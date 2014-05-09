FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| "track#{n}"}
    sequence(:path) {|n| "/zenodotus/track#{n}"}
  end
end
