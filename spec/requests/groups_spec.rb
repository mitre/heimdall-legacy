require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Groups', type: :request do
  describe 'GET /profile/:profile_id/group/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:group).attributes
      }

      it 'works! (now write some real specs)' do
        sign_in_as_a_valid_user
        profile = create :profile, created_by: @user
        group = profile.groups.create! valid_attributes
        get profile_group_path(profile, group)
        expect(response).to have_http_status(200)
      end
    end
  end
end
