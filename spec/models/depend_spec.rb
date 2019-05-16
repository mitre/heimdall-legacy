require 'rails_helper'

RSpec.describe Depend, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  it { is_expected.to be_embedded_in(:profile).as_inverse_of(:depends) }

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
