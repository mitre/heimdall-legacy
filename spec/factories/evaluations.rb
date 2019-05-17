FactoryBot.define do
  factory :evaluation, class: Evaluation do
    version { 'MyString' }
    other_checks { ['MyString'] }
  end
end
