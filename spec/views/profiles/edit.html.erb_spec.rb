require 'rails_helper'

RSpec.describe 'profiles/edit', type: :view do
  before(:each) do
    @profile = create :profile
    @depend = @profile.depends.new
    @support = @profile.supports.new
  end

  it 'renders the edit profile form' do
    render

    assert_select 'form[method=?]', 'post' do

      assert_select 'input[name=?]', 'profile[name]'

      assert_select 'input[name=?]', 'profile[title]'

      assert_select 'input[name=?]', 'profile[maintainer]'

      assert_select 'input[name=?]', 'profile[copyright]'

      assert_select 'input[name=?]', 'profile[copyright_email]'

      assert_select 'input[name=?]', 'profile[license]'

      assert_select 'input[name=?]', 'profile[summary]'

      assert_select 'input[name=?]', 'profile[version]'

    end
  end
end
