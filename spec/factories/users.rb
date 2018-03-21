FactoryGirl.define do
  factory :user, class: User do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    factory :editor do
      sequence(:email) { |n| "editor_#{n}@example.com" }
      after(:create) { |user| user.add_role(:editor) }
    end

    factory :admin do
      sequence(:email) { |n| "admin_#{n}@example.com" }
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
