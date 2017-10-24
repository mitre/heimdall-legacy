require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  before(:each) do
    assign(:groups, [
      Group.create!(
        :title => "Title",
        :controls => "Controls",
        :control_id => "Control"
      ),
      Group.create!(
        :title => "Title",
        :controls => "Controls",
        :control_id => "Control"
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Controls".to_s, :count => 2
    assert_select "tr>td", :text => "Control".to_s, :count => 2
  end
end
