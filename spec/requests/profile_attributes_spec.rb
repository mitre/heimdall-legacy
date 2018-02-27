require 'rails_helper'

RSpec.describe "ProfileAttributes", type: :request do
  describe "GET /profile/:profile_id/profile_attribute/:id" do
    context "with valid params" do
      let(:valid_attributes) {
        FactoryGirl.build(:profile_attribute).attributes
      }

      it "works! (now write some real specs)" do
        profile = create :profile
        profile_attribute = profile.profile_attributes.create! valid_attributes
        get profile_profile_attribute_path(profile, profile_attribute)
        expect(response).to have_http_status(200)
      end
    end
  end
end
