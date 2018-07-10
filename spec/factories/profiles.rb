FactoryBot.define do
  factory :profile, class: Profile do
    name 'MyString'
    title 'MyString'
    maintainer 'MyString'
    copyright 'MyString'
    copyright_email 'MyString'
    license 'MyString'
    summary 'MyString'
    version 'MyString'
    sha256 'MyString'
  end

  factory :profile2, class: Profile do
    name 'MyString2'
    title 'MyString2'
    maintainer 'MyString2'
    copyright 'MyString2'
    copyright_email 'MyString2'
    license 'MyString2'
    summary 'MyString2'
    version 'MyString2'
    sha256 'MyString2'
  end

  factory :invalid_profile, class: Profile do
    name nil
    title nil
    maintainer 'MyString'
    copyright 'MyString'
    copyright_email 'MyString'
    license 'MyString'
    summary 'MyString'
    version 'MyString'
    sha256 nil
  end

end
