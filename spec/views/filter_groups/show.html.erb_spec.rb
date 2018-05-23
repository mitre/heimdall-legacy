require 'rails_helper'

RSpec.describe 'filter_groups/show', type: :view do
  before(:each) do
    @filter_group = assign(:filter_group, FilterGroup.create!(
                                            name: 'Name',
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
