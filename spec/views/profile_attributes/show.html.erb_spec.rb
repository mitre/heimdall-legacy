require 'rails_helper'

RSpec.describe 'profile_attributes/show', type: :view do
  before(:each) do
    valid_attributes = { name: 'MyString2', option_description: 'MyString2', option_default: ['MyString2'] }
    @profile = create :profile
    @profile_attribute = @profile.profile_attributes.create! valid_attributes
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Option Description/)
  end
end
