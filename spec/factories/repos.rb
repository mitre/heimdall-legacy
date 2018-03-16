FactoryGirl.define do
  factory :repo, class: Repo do
    name "GitLab MITRE"
    api_url "https://gitlab.mitre.org/api/v3"
    repo_type "GitLab"
  end

  factory :gitlab_repo, class: Repo do
    name "GitLab MITRE"
    api_url "https://gitlab.mitre.org/api/v3"
    repo_type "GitLab"
  end

  factory :github_repo, class: Repo do
    name "GitHub"
    api_url "https://api.github.com/"
    repo_type "GitHub"
  end
end
