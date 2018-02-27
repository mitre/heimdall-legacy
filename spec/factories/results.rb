FactoryGirl.define do
  factory :result, :class => Result do
    status "MyString"
    code_desc "MyString"
    skip_message "MyString"
    resource "MyString"
    run_time 1.5
    start_time "2017-10-26"
    backtrace ["String1"]
    evaluation
    control
  end

  factory :invalid_result, :class => Result do
    status "MyString2"
    code_desc "MyString2"
    skip_message "MyString2"
    resource "MyString2"
    run_time 1.5
    start_time "2017-10-26"
    backtrace "String1"
    evaluation
    control
  end
end
