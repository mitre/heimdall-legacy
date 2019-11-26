FactoryBot.define do
  factory :finding, class: Finding do
    passed { 23 }
    failed { 43 }
    not_reviewed { 23 }
    profile_error { 10 }
    not_applicable { 18 }
  end
end
