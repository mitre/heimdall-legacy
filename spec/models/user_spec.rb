require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to be_mongoid_document }

  context 'with User' do
    let(:user) { FactoryBot.create(:user) }
    let(:evaluation) { FactoryBot.build(:evaluation) }
    let(:profile) { FactoryBot.build(:profile) }

    it 'get readability from circle' do
      circle = create :circle, created_by: user
      user.add_role(:owner, circle)
      circle.evaluations << evaluation
      circle.profiles << profile
      expect(user.readable_evaluation?(evaluation.id)).to eq true
      expect(user.readable_profile?(profile.id)).to eq true
      expect(user.my_profiles).to be_empty
      expect(user.my_evaluations).to be_empty
    end
  end
end
