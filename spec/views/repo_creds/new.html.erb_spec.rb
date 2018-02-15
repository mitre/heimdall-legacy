require 'rails_helper'

RSpec.describe "repo_creds/new", type: :view do
  before(:each) do
    assign(:repo_cred, RepoCred.new(
      :username => "MyString",
      :token => "MyString"
    ))
  end

  it "renders new repo_cred form" do
    render

    assert_select "form[action=?][method=?]", repo_creds_path, "post" do

      assert_select "input[name=?]", "repo_cred[username]"

      assert_select "input[name=?]", "repo_cred[token]"
    end
  end
end
