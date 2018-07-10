FactoryBot.define do
  factory :dependency, class: Depend do
    name 'MyString'
    path 'MyString'
  end

  factory :invalid_dependency, class: Depend do
    path 'MyString2'
  end
end
