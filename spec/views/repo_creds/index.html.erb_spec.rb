require 'rails_helper'

RSpec.describe "repo_creds/index", type: :view do
  before(:each) do
    assign(:repo_creds, [
      RepoCred.create!(
        :username => "Username",
        :token => "Token"
      ),
      RepoCred.create!(
        :username => "Username",
        :token => "Token"
      )
    ])
  end

  it "renders a list of repo_creds" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
  end
end
