require 'rails_helper'

RSpec.describe "controls/edit", type: :view do
  before(:each) do
    @control = create :control
    @profile = @control.profile
  end

  it "renders the edit control form" do
    render

    assert_select "form[action=?][method=?]", profile_control_path(@profile, @control), "post" do
      assert_select "textarea[name=?]", "control[code]"
    end
  end
end
