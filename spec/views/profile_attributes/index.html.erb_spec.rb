require 'rails_helper'

RSpec.describe "profile_attributes/index", type: :view do
  before(:each) do
    assign(:profile_attributes, [
      ProfileAttribute.create!(
        :name => "Name",
        :option_description => "Option Description",
        :option_default => "Option Default"
      ),
      ProfileAttribute.create!(
        :name => "Name",
        :option_description => "Option Description",
        :option_default => "Option Default"
      )
    ])
  end

  it "renders a list of profile_attributes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Option Description".to_s, :count => 2
    assert_select "tr>td", :text => "Option Default".to_s, :count => 2
  end
end
