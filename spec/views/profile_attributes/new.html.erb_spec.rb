require 'rails_helper'

RSpec.describe "profile_attributes/new", type: :view do
  before(:each) do
    assign(:profile_attribute, ProfileAttribute.new(
      :name => "MyString",
      :option_description => "MyString",
      :option_default => "MyString"
    ))
  end

  it "renders new profile_attribute form" do
    render

    assert_select "form[action=?][method=?]", profile_attributes_path, "post" do

      assert_select "input[name=?]", "profile_attribute[name]"

      assert_select "input[name=?]", "profile_attribute[option_description]"

      assert_select "input[name=?]", "profile_attribute[option_default]"
    end
  end
end
