require 'rails_helper'

RSpec.describe "evaluations/new", type: :view do
  before(:each) do
    assign(:evaluation, Evaluation.new(
      :version => "MyString",
      :other_checks => "MyString",
      :platform_name => "MyString",
      :platform_release => "MyString",
      :statistics_duration => "MyString"
    ))
  end

  it "renders new evaluation form" do
    render

    assert_select "form[action=?][method=?]", evaluations_path, "post" do

      assert_select "input[name=?]", "evaluation[version]"

      assert_select "input[name=?]", "evaluation[other_checks]"

      assert_select "input[name=?]", "evaluation[platform_name]"

      assert_select "input[name=?]", "evaluation[platform_release]"

      assert_select "input[name=?]", "evaluation[statistics_duration]"
    end
  end
end
