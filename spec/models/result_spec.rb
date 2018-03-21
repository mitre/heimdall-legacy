require 'rails_helper'

RSpec.describe Result, type: :model do
  context 'Result built' do
    let(:result) { FactoryGirl.build(:result) }

    it 'get not_tested status_symbol' do
      expect(result.status_symbol).to eq :not_tested
    end

    it 'get open status_symbol' do
      result.status = 'failed'
      expect(result.status_symbol).to eq :open
    end

    it 'get passed status_symbol' do
      result.status = 'passed'
      expect(result.status_symbol).to eq :not_a_finding
    end

    it 'get skipped status_symbol' do
      result.status = 'skipped'
      expect(result.status_symbol).to eq :not_reviewed
    end
  end
end
