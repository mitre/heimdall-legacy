require 'rails_helper'

RSpec.describe "repos/show", type: :view do
  before(:each) do
    @repo = assign(:repo, Repo.create!(
      :name => "Name",
      :api_url => "Api Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Api Url/)
  end
end
