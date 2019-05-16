require 'rails_helper'

RSpec.describe 'results/show', type: :view do
  context 'Editor is logged in' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      sign_in user
    end

    before(:each) do
      @evaluation = create :evaluation, created_by: user
      @profile = create :profile, created_by: user
      @control = create :control, profile_id: @profile.id, created_by: user
      @result = create :result, evaluation_id: @evaluation.id, control_id: @control.id, created_by: user
    end

    it 'renders attributes' do
      render
      expect(rendered).to match(/Status/)
      expect(rendered).to match(/Resource/)
    end
  end
end
