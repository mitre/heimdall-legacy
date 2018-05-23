require 'rails_helper'

RSpec.describe 'filter_groups/new', type: :view do
  before(:each) do
    assign(:filter_group, FilterGroup.new(
                            name: 'MyString',
    ))
  end

  it 'renders new filter_group form' do
    render

    assert_select 'form[action=?][method=?]', filter_groups_path, 'post' do

      assert_select 'input[name=?]', 'filter_group[name]'
    end
  end
end
