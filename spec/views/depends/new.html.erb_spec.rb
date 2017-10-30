require 'rails_helper'

RSpec.describe "depends/new", type: :view do
  before(:each) do
    assign(:depend, Depend.new(
      :name => "MyString",
      :path => "MyString"
    ))
  end

  it "renders new depend form" do
    render

    assert_select "form[action=?][method=?]", depends_path, "post" do

      assert_select "input[name=?]", "depend[name]"

      assert_select "input[name=?]", "depend[path]"
    end
  end
end
