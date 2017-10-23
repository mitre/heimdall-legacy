require 'rails_helper'

RSpec.describe "profiles/new", type: :view do
  before(:each) do
    assign(:profile, Profile.new(
      :name => "MyString",
      :title => "MyString",
      :maintainer => "MyString",
      :copyright => "MyString",
      :copyright_email => "MyString",
      :license => "MyString",
      :summary => "MyString",
      :version => "MyString",
      :sha256 => "MyString",
      :depends => "MyText",
      :supports => "MyText",
      :controls => "MyText",
      :groups => "MyText",
      :profile_attributes => "MyText"
    ))
  end

  it "renders new profile form" do
    render

    assert_select "form[action=?][method=?]", profiles_path, "post" do

      assert_select "input[name=?]", "profile[name]"

      assert_select "input[name=?]", "profile[title]"

      assert_select "input[name=?]", "profile[maintainer]"

      assert_select "input[name=?]", "profile[copyright]"

      assert_select "input[name=?]", "profile[copyright_email]"

      assert_select "input[name=?]", "profile[license]"

      assert_select "input[name=?]", "profile[summary]"

      assert_select "input[name=?]", "profile[version]"

      assert_select "input[name=?]", "profile[sha256]"

      assert_select "textarea[name=?]", "profile[depends]"

      assert_select "textarea[name=?]", "profile[supports]"

      assert_select "textarea[name=?]", "profile[controls]"

      assert_select "textarea[name=?]", "profile[groups]"

      assert_select "textarea[name=?]", "profile[profile_attributes]"
    end
  end
end
