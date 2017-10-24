require 'rails_helper'

RSpec.describe "profile_attributes/edit", type: :view do
  before(:each) do
    @profile_attribute = assign(:profile_attribute, ProfileAttribute.create!(
      :name => "MyString",
      :option_description => "MyString",
      :option_default => "MyString"
    ))
  end

  it "renders the edit profile_attribute form" do
    render

    assert_select "form[action=?][method=?]", profile_attribute_path(@profile_attribute), "post" do

      assert_select "input[name=?]", "profile_attribute[name]"

      assert_select "input[name=?]", "profile_attribute[option_description]"

      assert_select "input[name=?]", "profile_attribute[option_default]"
    end
  end
end
