require 'rails_helper'

RSpec.describe "results/index", type: :view do
  before(:each) do
    assign(:results, [
      Result.create!(
        :status => "Status",
        :code_desc => "Code Desc",
        :skip_message => "Skip Message",
        :resource => "Resource",
        :run_time => 2.5
      ),
      Result.create!(
        :status => "Status",
        :code_desc => "Code Desc",
        :skip_message => "Skip Message",
        :resource => "Resource",
        :run_time => 2.5
      )
    ])
  end

  it "renders a list of results" do
    render
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Code Desc".to_s, :count => 2
    assert_select "tr>td", :text => "Skip Message".to_s, :count => 2
    assert_select "tr>td", :text => "Resource".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
  end
end
