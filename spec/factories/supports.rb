FactoryBot.define do
  factory :support, class: Support do
    os_family 'Windows'
  end

  factory :invalid_support, class: Support do
    os_family 'Not Unix'
  end
end
