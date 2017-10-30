require 'rails_helper'

RSpec.describe "evaluations/index", type: :view do
  before(:each) do
    assign(:evaluations, [
      Evaluation.create!(
        :version => "Version",
        :other_checks => "Other Checks",
        :platform_name => "Platform Name",
        :platform_release => "Platform Release",
        :statistics_duration => "Statistics Duration"
      ),
      Evaluation.create!(
        :version => "Version",
        :other_checks => "Other Checks",
        :platform_name => "Platform Name",
        :platform_release => "Platform Release",
        :statistics_duration => "Statistics Duration"
      )
    ])
  end

  it "renders a list of evaluations" do
    render
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    assert_select "tr>td", :text => "Other Checks".to_s, :count => 2
    assert_select "tr>td", :text => "Platform Name".to_s, :count => 2
    assert_select "tr>td", :text => "Platform Release".to_s, :count => 2
    assert_select "tr>td", :text => "Statistics Duration".to_s, :count => 2
  end
end
