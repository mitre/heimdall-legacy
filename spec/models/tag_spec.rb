require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_embedded_in(:control).as_inverse_of(:tags) }

  context 'Evaluation imported' do
    let(:tag) { Tag.new(name: 'name', value: 'value') }
    let(:tag2) { Tag.new(name: 'name', value: ['AC-12', 'value2']) }

    it 'gets good_values' do
      value = tag.good_values
      expect(value).to eq []
    end

    it 'gets good_values from array' do
      value = tag2.good_values
      expect(value).to eq ['AC-12']
      expect(value.first.numeric?).to eq false
    end
  end
end
