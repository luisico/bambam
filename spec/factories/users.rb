FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:first_name) {|n| "Firstname#{n}"}
    sequence(:last_name) {|n| "Lastname#{n}"}
    password '123456789'
    password_confirmation '123456789'

    factory :admin,  :aliases => [:owner] do
      sequence(:email) {|n| "admin#{n}@example.com"}
      after(:create) {|user| user.add_role(:admin)}
    end

    factory :inviter do
      sequence(:email) {|n| "inviter#{n}@example.com"}
      after(:create) {|user| user.add_role(:inviter)}
    end
  end
end
