FactoryBot.define do
  factory :result, class: Result do
    status 'MyString'
    code_desc 'MyString'
    skip_message 'MyString'
    resource 'MyString'
    run_time 1.5
    start_time '2017-10-26'
    backtrace ['String1']
  end
end
