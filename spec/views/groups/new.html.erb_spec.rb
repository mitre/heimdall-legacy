require 'rails_helper'

RSpec.describe 'groups/new', type: :view do
  before(:each) do
    valid_attributes = { title: 'MyString2', controls: ['MyString2'], control_id: 'MyString2' }
    @profile = create :profile
    @group = @profile.groups.create! valid_attributes
  end

  it 'renders new group form' do
    render

    assert_select 'form[method=?]', 'post' do

      assert_select 'input[name=?]', 'group[title]'

      assert_select 'input[name=?]', 'group[control_id]'
    end
  end
end
