# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:name) {|n| "Lab#{n}"}
    owner

    after(:build) do |group|
      group.members << group.owner unless group.members.include?(group.owner)
    end
  end
end
