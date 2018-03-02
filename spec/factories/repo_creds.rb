FactoryGirl.define do
  factory :repo_cred, :class => RepoCred do
    username "MyString"
    token "MyString"
    repo
  end
end
