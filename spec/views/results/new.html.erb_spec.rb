require 'rails_helper'

RSpec.describe "results/new", type: :view do
  before(:each) do
    assign(:result, Result.new(
      :status => "MyString",
      :code_desc => "MyString",
      :skip_message => "MyString",
      :resource => "MyString",
      :run_time => 1.5
    ))
  end

  it "renders new result form" do
    render

    assert_select "form[action=?][method=?]", results_path, "post" do

      assert_select "input[name=?]", "result[status]"

      assert_select "input[name=?]", "result[code_desc]"

      assert_select "input[name=?]", "result[skip_message]"

      assert_select "input[name=?]", "result[resource]"

      assert_select "input[name=?]", "result[run_time]"
    end
  end
end
