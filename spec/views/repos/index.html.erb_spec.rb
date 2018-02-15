require 'rails_helper'

RSpec.describe "repos/index", type: :view do
  before(:each) do
    assign(:repos, [
      Repo.create!(
        :name => "Name",
        :api_url => "Api Url"
      ),
      Repo.create!(
        :name => "Name",
        :api_url => "Api Url"
      )
    ])
  end

  it "renders a list of repos" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Api Url".to_s, :count => 2
  end
end
