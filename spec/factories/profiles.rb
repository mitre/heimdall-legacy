FactoryGirl.define do
  factory :profile, :class => Profile do
    name "MyString"
    title "MyString"
    maintainer "MyString"
    copyright "MyString"
    copyright_email "MyString"
    license "MyString"
    summary "MyString"
    version "MyString"
    sha256 "MyString"
    #depends "MyText1"
    #supports "MyText2"
    #controls "MyText3"
    #groups "MyText4"
    #profile_attributes "MyText5"
  end

  factory :profile2, :class => Profile do
    name "MyString2"
    title "MyString2"
    maintainer "MyString2"
    copyright "MyString2"
    copyright_email "MyString2"
    license "MyString2"
    summary "MyString2"
    version "MyString2"
    sha256 "MyString2"
  end

  factory :invalid_profile, :class => Profile do
    maintainer "MyString"
    copyright "MyString"
    copyright_email "MyString"
    license "MyString"
    summary "MyString"
    version "MyString"
  end

end
