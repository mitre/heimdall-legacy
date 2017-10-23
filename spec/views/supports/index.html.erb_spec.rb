require 'rails_helper'

RSpec.describe "supports/index", type: :view do
  before(:each) do
    assign(:supports, [
      Support.create!(
        :os_family => "Os Family"
      ),
      Support.create!(
        :os_family => "Os Family"
      )
    ])
  end

  it "renders a list of supports" do
    render
    assert_select "tr>td", :text => "Os Family".to_s, :count => 2
  end
end
