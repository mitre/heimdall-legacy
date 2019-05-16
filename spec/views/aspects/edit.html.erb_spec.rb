require 'rails_helper'

RSpec.describe 'profile_attributes/edit', type: :view do
  before(:each) do
    valid_attributes = { name: 'MyString2', option_description: 'MyString2', option_default: ['MyString2'] }
    @profile = create :profile
    @profile_attribute = @profile.profile_attributes.create! valid_attributes
  end

  it 'renders the edit profile_attribute form' do
    render

    assert_select 'form[method=?]', 'post' do

      assert_select 'input[name=?]', 'profile_attribute[name]'

      assert_select 'input[name=?]', 'profile_attribute[option_description]'

    end
  end
end
