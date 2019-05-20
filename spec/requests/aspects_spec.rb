require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Aspects', type: :request do
  describe 'GET /profile/:profile_id/aspect/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:aspect).attributes
      }

      it 'gets the show page' do
        sign_in_as_a_valid_user
        profile = create :profile, created_by: @user
        aspect = profile.aspects.create! valid_attributes
        get profile_aspect_path(profile, aspect)
        expect(response).to have_http_status(200)
      end
    end
  end
end
