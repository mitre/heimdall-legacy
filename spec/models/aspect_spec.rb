require 'rails_helper'

RSpec.describe Aspect, type: :model do
  context 'with Aspect' do
    let(:aspect) { FactoryBot.build(:aspect) }

    it 'set option_default_list' do
      aspect.option_default_list='option1, option2'
      expect(aspect.option_default).to eq %w{option1 option2}
    end

    it 'get build json string' do
      expect(aspect.to_json).to be_a(String)
      expect(JSON.parse(aspect.to_json)).to have_key('name')
    end

    it 'get build json' do
      expect(aspect.as_json).to have_key('name')
    end
  end
end
