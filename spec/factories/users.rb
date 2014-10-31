FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:first_name) {|n| "Firstname#{n}"}
    sequence(:last_name) {|n| "Lastname#{n}"}
    password '123456789'
    password_confirmation '123456789'

    trait :unnamed do
      first_name nil
      last_name nil
    end

    # TODO: remove :owner alias
    factory :admin,  aliases: [:owner] do
      sequence(:email) {|n| "admin#{n}@example.com"}
      sequence(:first_name) {|n| "Firstname#{n}"}
      sequence(:last_name) {|n| "Admin#{n}"}
      after(:build) {|user| user.add_role(:admin)}
    end

    factory :manager do
      sequence(:email) {|n| "manager#{n}@example.com"}
      sequence(:first_name) {|n| "Firstname#{n}"}
      sequence(:last_name) {|n| "Manager#{n}"}
      after(:create) {|user| user.add_role(:manager)}
    end

    # after :build do |user|
    #   user.groups << FactoryGirl.build(:group)
    # end

    # before(:create) do |user|
    #   create(:group, members: [user])
    # end

    # after(:build) do |user, evaluator|
    #   user.groups << FactoryGirl.build(:group, members: [user])
    # end

    # after(:create) do |user|
    #   create(:group, members: [user])
    # end

    # after(:create) do |user, evaluator|
    #   user.groups << create(:group, members: [user])
    # end

    after(:build) do |user|
      create(:group, members: [user]) unless user.email.include? "admin"
    end
  end
end
