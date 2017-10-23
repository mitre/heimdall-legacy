require 'rails_helper'

RSpec.describe "profiles/index", type: :view do
  before(:each) do
    assign(:profiles, [
      Profile.create!(
        :name => "Name",
        :title => "Title",
        :maintainer => "Maintainer",
        :copyright => "Copyright",
        :copyright_email => "Copyright Email",
        :license => "License",
        :summary => "Summary",
        :version => "Version",
        :sha256 => "Sha256",
        :depends => "MyText",
        :supports => "MyText",
        :controls => "MyText",
        :groups => "MyText",
        :profile_attributes => "MyText"
      ),
      Profile.create!(
        :name => "Name",
        :title => "Title",
        :maintainer => "Maintainer",
        :copyright => "Copyright",
        :copyright_email => "Copyright Email",
        :license => "License",
        :summary => "Summary",
        :version => "Version",
        :sha256 => "Sha256",
        :depends => "MyText",
        :supports => "MyText",
        :controls => "MyText",
        :groups => "MyText",
        :profile_attributes => "MyText"
      )
    ])
  end

  it "renders a list of profiles" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Maintainer".to_s, :count => 2
    assert_select "tr>td", :text => "Copyright".to_s, :count => 2
    assert_select "tr>td", :text => "Copyright Email".to_s, :count => 2
    assert_select "tr>td", :text => "License".to_s, :count => 2
    assert_select "tr>td", :text => "Summary".to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    assert_select "tr>td", :text => "Sha256".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
