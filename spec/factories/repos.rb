FactoryGirl.define do
  factory :repo, class: Repo do
    name 'GitLab MITRE'
    api_url 'https://gitlab.mitre.org/api/v3'
    repo_type 'GitLab'

    trait :github do
      repo_type 'GitHub'
    end
  end

  factory :gitlab_repo, class: Repo do
    name 'GitLab MITRE'
    api_url 'https://gitlab.mitre.org/api/v3'
    repo_type 'GitLab'
  end

end
