require 'rails_helper'

RSpec.describe "depends/show", type: :view do
  before(:each) do
    @depend = assign(:depend, Depend.create!(
      :name => "Name",
      :path => "Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Path/)
  end
end
