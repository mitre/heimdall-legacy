require 'rails_helper'

RSpec.describe 'filter_groups/edit', type: :view do
  before(:each) do
    @filter_group = assign(:filter_group, FilterGroup.create!(
                                            name: 'MyString',
    ))
  end

  it 'renders the edit filter_group form' do
    render

    assert_select 'form[action=?][method=?]', filter_group_path(@filter_group), 'post' do

      assert_select 'input[name=?]', 'filter_group[name]'
    end
  end
end
