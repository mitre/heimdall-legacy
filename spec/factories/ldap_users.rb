FactoryBot.define do
  factory :ldap_user, class: LdapUser do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'foobar'
    api_key 'w736r387dg278346dh2i7h6d7'

    factory :ldap_editor do
      sequence(:email) { |n| "editor_#{n}@example.com" }
      after(:create) { |user| user.add_role(:editor) }
    end
  end
end
