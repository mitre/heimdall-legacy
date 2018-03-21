require 'rails_helper'

RSpec.describe 'groups/show', type: :view do
  before(:each) do
    valid_attributes = { title: 'MyString2', controls: ['MyString2'], control_id: 'MyString2' }
    @profile = create :profile
    @group = @profile.groups.create! valid_attributes
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Control ID/)
  end
end
