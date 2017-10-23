require 'rails_helper'

RSpec.describe "controls/show", type: :view do
  before(:each) do
    @control = assign(:control, Control.create!(
      :title => "Title",
      :desc => "Desc",
      :impact => 2.5,
      :refs => "Refs",
      :code => "MyText",
      :control_id => "Id"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Desc/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/Refs/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Id/)
  end
end
