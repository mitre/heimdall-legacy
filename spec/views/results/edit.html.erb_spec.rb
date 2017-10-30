require 'rails_helper'

RSpec.describe "results/edit", type: :view do
  before(:each) do
    @result = assign(:result, Result.create!(
      :status => "MyString",
      :code_desc => "MyString",
      :skip_message => "MyString",
      :resource => "MyString",
      :run_time => 1.5
    ))
  end

  it "renders the edit result form" do
    render

    assert_select "form[action=?][method=?]", result_path(@result), "post" do

      assert_select "input[name=?]", "result[status]"

      assert_select "input[name=?]", "result[code_desc]"

      assert_select "input[name=?]", "result[skip_message]"

      assert_select "input[name=?]", "result[resource]"

      assert_select "input[name=?]", "result[run_time]"
    end
  end
end
