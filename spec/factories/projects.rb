# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    sequence(:name) {|n| "project#{n}"}
    owner

    after(:build) do |project|
      project.users << project.owner unless project.users.include?(project.owner)
    end
  end
end
