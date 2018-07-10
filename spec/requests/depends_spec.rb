require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Depends', type: :request do
  describe 'DELETE /profile/:profile_id/depend/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:dependency).attributes
      }

      it 'works! (now write some real specs)' do
        sign_in_as_a_valid_user
        profile = create :profile, created_by: @user
        depend = profile.depends.create! valid_attributes
        delete profile_depend_path(profile, depend)
        expect(response).to redirect_to(edit_profile_url(profile))
      end
    end
  end
end
