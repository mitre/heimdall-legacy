require 'rails_helper'

RSpec.describe 'controls/edit', type: :view do

  context 'Editor is logged in' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      sign_in user
    end

    before(:each) do
      @profile = create :profile, created_by: user
      @control = create :control, profile_id: @profile.id, created_by: user
    end

    it 'renders the edit control form' do
      render

      assert_select 'form[action=?][method=?]', profile_control_path(@profile, @control), 'post' do
        assert_select 'textarea[name=?]', 'control[code]'
      end
    end
  end
end
