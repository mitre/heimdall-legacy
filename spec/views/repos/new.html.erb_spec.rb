require 'rails_helper'

RSpec.describe "repos/new", type: :view do
  before(:each) do
    assign(:repo, Repo.new(
      :name => "MyString",
      :api_url => "MyString"
    ))
  end

  it "renders new repo form" do
    render

    assert_select "form[action=?][method=?]", repos_path, "post" do

      assert_select "input[name=?]", "repo[name]"

      assert_select "input[name=?]", "repo[api_url]"
    end
  end
end
