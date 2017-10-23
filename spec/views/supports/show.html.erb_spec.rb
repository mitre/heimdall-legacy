require 'rails_helper'

RSpec.describe "supports/show", type: :view do
  before(:each) do
    @support = assign(:support, Support.create!(
      :os_family => "OS Family"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Os Family/)
  end
end
