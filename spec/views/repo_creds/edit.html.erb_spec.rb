require 'rails_helper'

RSpec.describe "repo_creds/edit", type: :view do
  before(:each) do
    @repo_cred = assign(:repo_cred, RepoCred.create!(
      :username => "MyString",
      :token => "MyString"
    ))
  end

  it "renders the edit repo_cred form" do
    render

    assert_select "form[action=?][method=?]", repo_cred_path(@repo_cred), "post" do

      assert_select "input[name=?]", "repo_cred[username]"

      assert_select "input[name=?]", "repo_cred[token]"
    end
  end
end
