require 'rails_helper'

RSpec.describe Depend, type: :model do
  context 'with Depend' do
    let(:depend) { FactoryBot.build(:dependency) }

    it 'get build json string' do
      expect(depend.to_json).to be_a(String)
      expect(JSON.parse(depend.to_json)).to have_key('name')
    end

    it 'get build json' do
      expect(depend.as_json).to have_key('name')
    end
  end
end
