require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  context 'Evaluation imported' do
    let(:eval) { Evaluation.parse(JSON.parse(File.open("spec/support/bad_nginx.json", "r").read))}

    it "get status_counts" do
      counts, controls = eval.status_counts
      expect(counts).to_not be_empty
      expect(counts).to include(
        open:           3,
        not_a_finding:  33,
        not_reviewed:   3,
        not_tested:     1,
        not_applicable: 1,
      )
      expect(controls.size).to eq 41
    end

    it "get status_symbol_value" do
      value = eval.status_symbol_value :not_applicable
      expect(value).to eq 0.2
      value = eval.status_symbol_value :not_reviewed
      expect(value).to eq 0.4
      value = eval.status_symbol_value :not_a_finding
      expect(value).to eq 0.6
      value = eval.status_symbol_value :open
      expect(value).to eq 0.8
      value = eval.status_symbol_value nil
      expect(value).to eq 0.0
    end

    it "get nist_hash" do
      nist = eval.nist_hash nil, nil
      expect(nist).to_not be_empty
      expect(nist).to have_key("CM-6")
    end

    it "get parse with bad data" do
      nist = Evaluation.parse JSON.parse('{"some": "nonsense", "instead": "of an evaluation"}')
      expect(nist).to be_nil
    end
  end
end
