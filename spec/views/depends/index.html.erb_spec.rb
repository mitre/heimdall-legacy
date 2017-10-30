require 'rails_helper'

RSpec.describe "depends/index", type: :view do
  before(:each) do
    assign(:depends, [
      Depend.create!(
        :name => "Name",
        :path => "Path"
      ),
      Depend.create!(
        :name => "Name",
        :path => "Path"
      )
    ])
  end

  it "renders a list of depends" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Path".to_s, :count => 2
  end
end
