require 'rails_helper'

RSpec.describe 'aspects/show', type: :view do
  context 'with valid params' do
    let(:user) { FactoryBot.create(:user) }
    before(:each) do
      valid_attributes = { name: 'MyString2', options: { description: 'MyString2', default: ['MyString2'] } }
      @profile = create :profile, created_by: user
      @aspect = @profile.aspects.create! valid_attributes
    end

    it 'renders attributes' do
      render
      expect(rendered).to match(/Name/)
      expect(rendered).to match(/Description/)
    end
  end
end
