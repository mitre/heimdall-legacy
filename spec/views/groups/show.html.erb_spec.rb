require 'rails_helper'

RSpec.describe "groups/show", type: :view do
  before(:each) do
    @group = assign(:group, Group.create!(
      :title => "Title",
      :controls => "Controls",
      :control_id => "Control"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Controls/)
    expect(rendered).to match(/Control/)
  end
end
