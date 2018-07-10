require 'rails_helper'

RSpec.describe Circle, type: :model do
  it { is_expected.to be_mongoid_document }

  context 'Evaluation imported' do
    let(:circle) { FactoryBot.build(:circle) }
    let(:eval) { FactoryBot.create(:evaluation) }

    it 'get recents' do
      circle.evaluations << eval
      recents = circle.recents
      expect(recents).to_not be_empty
    end
  end
end
