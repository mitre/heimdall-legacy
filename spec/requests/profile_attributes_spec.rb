require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'ProfileAttributes', type: :request do
  describe 'GET /profile/:profile_id/profile_attribute/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:profile_attribute).attributes
      }

      it 'works! (now write some real specs)' do
        sign_in_as_a_valid_user
        profile = create :profile, created_by: @user
        profile_attribute = profile.profile_attributes.create! valid_attributes
        get profile_profile_attribute_path(profile, profile_attribute)
        expect(response).to have_http_status(200)
      end
    end
  end
end
