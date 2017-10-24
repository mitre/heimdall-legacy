require 'rails_helper'

RSpec.describe "profile_attributes/show", type: :view do
  before(:each) do
    @profile_attribute = assign(:profile_attribute, ProfileAttribute.create!(
      :name => "Name",
      :option_description => "Option Description",
      :option_default => "Option Default"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Option Description/)
    expect(rendered).to match(/Option Default/)
  end
end
