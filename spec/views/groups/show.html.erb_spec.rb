require 'rails_helper'

RSpec.describe 'groups/show', type: :view do
  context 'with valid params' do
    let(:user) { FactoryBot.create(:user) }
    before(:each) do
      valid_attributes = { title: 'MyString2', controls: ['MyString2'], control_id: 'MyString2' }
      @profile = create :profile, created_by: user
      @group = @profile.groups.create! valid_attributes
    end

    it 'renders attributes' do
      render
      expect(rendered).to match(/Title/)
      expect(rendered).to match(/Control ID/)
    end
  end
end
