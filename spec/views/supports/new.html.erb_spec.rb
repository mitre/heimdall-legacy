require 'rails_helper'

RSpec.describe "supports/new", type: :view do
  before(:each) do
    assign(:support, Support.new(
      :os_family => "MyString"
    ))
  end

  it "renders new support form" do
    render

    assert_select "form[action=?][method=?]", supports_path, "post" do

      assert_select "input[name=?]", "support[os_family]"
    end
  end
end
