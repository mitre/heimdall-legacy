require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, Profile.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Maintainer/)
    expect(rendered).to match(/Copyright/)
    expect(rendered).to match(/Copyright Email/)
    expect(rendered).to match(/License/)
    expect(rendered).to match(/Summary/)
    expect(rendered).to match(/Version/)
    expect(rendered).to match(/Sha256/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
