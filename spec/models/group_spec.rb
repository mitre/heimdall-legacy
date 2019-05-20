require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'with Group' do
    let(:group) { FactoryBot.build(:group) }

    it 'get build json string' do
      expect(group.to_json).to be_a(String)
      expect(JSON.parse(group.to_json)).to have_key('title')
    end

    it 'get build json' do
      expect(group.as_json).to have_key('title')
    end
  end
end
