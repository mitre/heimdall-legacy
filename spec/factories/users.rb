FactoryBot.define do
  factory :user, class: DbUser do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'
    api_key 'w736r387dg278346dh2i7h6d7'

    factory :editor do
      sequence(:email) { |n| "editor_#{n}@example.com" }
      after(:create) { |user| user.add_role(:editor) }
    end

    factory :admin do
      sequence(:email) { |n| "admin_#{n}@example.com" }
      after(:create) { |user| user.add_role(:admin) }
    end
  end

  factory :old_user, class: DbUser do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'
  end
end
