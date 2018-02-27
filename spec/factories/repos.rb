FactoryGirl.define do
  factory :repo, :class => Repo do
    name "MyString"
    api_url "MyString"
    repo_type "GitLab"
  end
end
