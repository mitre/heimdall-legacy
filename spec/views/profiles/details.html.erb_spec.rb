require 'rails_helper'

RSpec.describe 'profiles/details', type: :view do
  context 'with valid params' do
    let(:user) { FactoryBot.create(:user) }
    before(:each) do
      @profile = create :profile, created_by: user
      @depend = @profile.depends.new
      @support = @profile.supports.new
    end

    it 'renders the profile details' do
      render
      expect(rendered).to match(/Finding Details/)
    end
  end
end
