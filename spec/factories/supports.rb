FactoryBot.define do
  factory :support, class: Support do
    name { 'os-family' }
    value { 'Windows' }
  end

  factory :invalid_support, class: Support do
    name { 'os_family' }
    value { 'Not Unix' }
  end
end
