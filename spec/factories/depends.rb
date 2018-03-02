FactoryGirl.define do
  factory :dependency, :class => Depend do
    name "MyString"
    path "MyString"
  end

  factory :invalid_dependency, :class => Depend do
    path "MyString"
  end
end
