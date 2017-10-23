require 'rails_helper'

RSpec.describe "controls/index", type: :view do
  before(:each) do
    assign(:controls, [
      Control.create!(
        :title => "Title",
        :desc => "Desc",
        :impact => 2.5,
        :refs => "Refs",
        :code => "MyText",
        :control_id => "Id"
      ),
      Control.create!(
        :title => "Title",
        :desc => "Desc",
        :impact => 2.5,
        :refs => "Refs",
        :code => "MyText",
        :control_id => "Id"
      )
    ])
  end

  it "renders a list of controls" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "Refs".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Id".to_s, :count => 2
  end
end
