require 'rails_helper'

RSpec.describe Control, type: :model do
  context 'with Control' do
    let(:control) { FactoryBot.build(:control) }

    it 'get short title' do
      expect(control.short_title).to eq 'The file permissions, ownership, and group membersh...'
    end

    it 'get low severity' do
      control.impact = 'low'
      expect(control.severity).to eq 'low'
    end

    it 'get medium severity' do
      control.impact = 'medium'
      expect(control.severity).to eq 'medium'
    end

    it 'get high severity' do
      control.impact = 'high'
      expect(control.severity).to eq 'high'
    end

    it 'get build json string' do
      expect(control.to_json).to be_a(String)
      expect(JSON.parse(control.to_json)).to have_key('title')
    end

    it 'get build json' do
      expect(control.as_json).to have_key('title')
    end

  end

  context 'Evaluation imported' do
    let(:user) { FactoryBot.create(:user) }
    let(:eval) { Evaluation.parse(JSON.parse(File.open('spec/support/ngadev-test1.json', 'r').read), user) }

    it 'get start time' do
      control = eval.profiles.first.controls.first
      expect(control.start_time.to_s).to eq '2018-04-08'
    end
  end
end
