require 'rails_helper'

RSpec.describe "controls/new", type: :view do
  before(:each) do
    @control = create :control
    @profile = @control.profile
  end

  it "renders new control form" do
    render

    assert_select "form[method=?]", "post" do

      assert_select "input[name=?]", "control[title]"

      assert_select "input[name=?]", "control[desc]"

      assert_select "input[name=?]", "control[impact]"

      assert_select "input[name=?]", "control[refs_list]"

      assert_select "textarea[name=?]", "control[code]"

      assert_select "input[name=?]", "control[control_id]"
    end
  end
end
