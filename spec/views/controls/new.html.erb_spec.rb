require 'rails_helper'

RSpec.describe 'controls/new', type: :view do

  context 'Editor is logged in' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      sign_in user
    end

    before(:each) do
      @profile = create :profile, created_by: user
      @control = create :control, profile_id: @profile.id, created_by: user
    end

    it 'renders new control form' do
      render

      assert_select 'form[method=?]', 'post' do

        assert_select 'input[name=?]', 'control[title]'

        assert_select 'input[name=?]', 'control[desc]'

        assert_select 'input[name=?]', 'control[impact]'

        assert_select 'input[name=?]', 'control[refs_list]'

        assert_select 'textarea[name=?]', 'control[code]'

        assert_select 'input[name=?]', 'control[control_id]'
      end
    end
  end
end
