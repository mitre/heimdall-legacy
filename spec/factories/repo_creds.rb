FactoryBot.define do
  factory :repo_cred, class: RepoCred do
    username 'someone@mitre.org'
    token 'MyString5345345645766'
    repo
  end

  factory :gitlab_cred, class: RepoCred do
    username 'someone@mitre.org'
    token 'MyString5345345645766'
    repo
  end

  factory :github_cred, class: RepoCred do
    username 'someone@mitre.org'
    token 'MyString5345345645766'
    association :repo, factory: [:repo, :github]
  end
end
