require 'rails_helper'

RSpec.describe "depends/edit", type: :view do
  before(:each) do
    @depend = assign(:depend, Depend.create!(
      :name => "MyString",
      :path => "MyString"
    ))
  end

  it "renders the edit depend form" do
    render

    assert_select "form[action=?][method=?]", depend_path(@depend), "post" do

      assert_select "input[name=?]", "depend[name]"

      assert_select "input[name=?]", "depend[path]"
    end
  end
end
