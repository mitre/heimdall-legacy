require 'rails_helper'

RSpec.describe "controls/new", type: :view do
  before(:each) do
    assign(:control, Control.new(
      :title => "MyString",
      :desc => "MyString",
      :impact => 1.5,
      :refs => "MyString",
      :code => "MyText",
      :control_id => "MyString"
    ))
  end

  it "renders new control form" do
    render

    assert_select "form[action=?][method=?]", controls_path, "post" do

      assert_select "input[name=?]", "control[title]"

      assert_select "input[name=?]", "control[desc]"

      assert_select "input[name=?]", "control[impact]"

      assert_select "input[name=?]", "control[refs]"

      assert_select "textarea[name=?]", "control[code]"

      assert_select "input[name=?]", "control[control_id]"
    end
  end
end
