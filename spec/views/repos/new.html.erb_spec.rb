require 'rails_helper'

RSpec.describe 'repos/new', type: :view do
  before(:each) do
    @repo = create :repo
  end

  it 'renders new repo form' do
    render

    assert_select 'form[method=?]', 'post' do

      assert_select 'input[name=?]', 'repo[name]'

      assert_select 'input[name=?]', 'repo[api_url]'
    end
  end
end
