FactoryBot.define do
  factory :group, class: Group do
    title 'MyString'
    controls ['MyString']
    control_id 'MyString'
  end

  factory :group2, class: Group do
    title 'MyString2'
    controls ['MyString2']
    control_id 'MyString2'
  end

  factory :invalid_group, class: Group do
    title 'MyString'
    controls 'MyString'
    control_id 'MyString'
  end
end
