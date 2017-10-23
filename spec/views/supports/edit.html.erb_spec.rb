require 'rails_helper'

RSpec.describe "supports/edit", type: :view do
  before(:each) do
    @support = assign(:support, Support.create!(
      :os_family => "MyString"
    ))
  end

  it "renders the edit support form" do
    render

    assert_select "form[action=?][method=?]", support_path(@support), "post" do

      assert_select "input[name=?]", "support[os_family]"
    end
  end
end
