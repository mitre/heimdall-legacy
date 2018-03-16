require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'with Group' do
    let(:group) { FactoryGirl.build(:group) }

    it 'set controls_list' do
      group.controls_list='control1, control2'
      expect(group.controls).to eq %w{control1 control2}
    end
  end
end
