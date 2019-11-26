require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  context 'Evaluation imported' do
    let(:user) { FactoryBot.create(:user) }
    let(:eval) { Evaluation.parse(JSON.parse(File.open('spec/support/bad_nginx.json', 'r').read), user) }

    it 'get findings' do
      expect(eval.finding.failed).to eq 3
      expect(eval.finding.passed).to eq 33
      expect(eval.finding.not_reviewed).to eq 4
      expect(eval.finding.profile_error).to eq 0
      expect(eval.finding.not_applicable).to eq 0
    end

    it 'get status_counts' do
      counts, controls, _ = eval.status_counts
      expect(counts).to_not be_empty
      expect(counts).to include(
        failed:           3,
        passed:  33,
        not_reviewed:   4,
        profile_error:     0,
        not_applicable: 0,
      )
      expect(controls.size).to eq 40
    end

    it 'get status_symbol_value' do
      value = eval.status_symbol_value :not_applicable
      expect(value).to eq 0.2
      value = eval.status_symbol_value :not_reviewed
      expect(value).to eq 0.4
      value = eval.status_symbol_value :passed
      expect(value).to eq 0.6
      value = eval.status_symbol_value :failed
      expect(value).to eq 0.8
      value = eval.status_symbol_value nil
      expect(value).to eq 0.0
    end

    it 'get nist_hash' do
      nist, _ = eval.nist_hash nil, nil, []
      expect(nist).to_not be_empty
      #expect(nist).to have_key('CM-6')
    end

    it 'get build json string' do
      expect(eval.to_json).to be_a(String)
      expect(JSON.parse(eval.to_json)).to have_key('version')
    end

    it 'get build json' do
      expect(eval.as_json).to have_key('version')
    end

    it 'get build ckl string' do
      expect(eval.to_ckl).to be_a(String)
    end

    it 'get parse with bad data' do
      nist = Evaluation.parse JSON.parse('{"some": "nonsense", "instead": "of an evaluation"}'), user
      expect(nist).to be_nil
    end
  end
  context 'Evaluation imported' do
    let(:user) { FactoryBot.create(:user) }
    let(:eval) { Evaluation.parse(JSON.parse(File.open('spec/support/ngadev-test1.json', 'r').read), user) }

    it 'get nist_hash' do
      nist, _ = eval.nist_hash nil, nil, []
      expect(nist).to_not be_empty
      expect(nist).to have_key('UM-1')
    end
  end
end
