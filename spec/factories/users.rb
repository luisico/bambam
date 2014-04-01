FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com"}
    password '123456789'
    password_confirmation '123456789'

    factory :admin do
      sequence(:email) {|n| "admin#{n}@example.com"}
      after(:create) {|user| user.add_role(:admin)}
    end
  end
end
