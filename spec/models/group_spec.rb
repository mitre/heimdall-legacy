require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'with Group' do
    let(:group) { FactoryBot.build(:group) }

    it 'set controls_list' do
      group.controls_list='control1, control2'
      expect(group.controls).to eq %w{control1 control2}
    end

    it 'get build json string' do
      expect(group.to_json).to be_a(String)
      expect(JSON.parse(group.to_json)).to have_key('title')
    end

    it 'get build json' do
      expect(group.as_json).to have_key('title')
    end
  end
end
