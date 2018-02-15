require 'rails_helper'

RSpec.describe "repo_creds/show", type: :view do
  before(:each) do
    @repo_cred = assign(:repo_cred, RepoCred.create!(
      :username => "Username",
      :token => "Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Token/)
  end
end
