FactoryBot.define do
  factory :aspect, class: Aspect do
    name { 'MyString' }
    option_description { 'MyString' }
    option_default { ['MyString'] }
  end
end
