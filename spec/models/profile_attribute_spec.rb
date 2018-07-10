require 'rails_helper'

RSpec.describe ProfileAttribute, type: :model do
  context 'with ProfileAttribute' do
    let(:profile_attribute) { FactoryBot.build(:profile_attribute) }

    it 'set option_default_list' do
      profile_attribute.option_default_list='option1, option2'
      expect(profile_attribute.option_default).to eq %w{option1 option2}
    end

    it 'get build json string' do
      expect(profile_attribute.to_json).to be_a(String)
      expect(JSON.parse(profile_attribute.to_json)).to have_key('name')
    end

    it 'get build json' do
      expect(profile_attribute.as_json).to have_key('name')
    end
  end
end
