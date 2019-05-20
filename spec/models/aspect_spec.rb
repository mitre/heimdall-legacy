require 'rails_helper'

RSpec.describe Aspect, type: :model do
  context 'with Aspect' do
    let(:aspect) { FactoryBot.build(:aspect) }

    it 'get build json string' do
      expect(aspect.to_json).to be_a(String)
      expect(JSON.parse(aspect.to_json)).to have_key('name')
    end

    it 'get build json' do
      expect(aspect.as_json).to have_key('name')
    end
  end
end
