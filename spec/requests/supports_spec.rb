require 'rails_helper'

RSpec.describe "Supports", type: :request do
  describe "DELETE /profile/:profile_id/support/:id" do
    context "with valid params" do
      let(:valid_attributes) {
        FactoryGirl.build(:support).attributes
      }

      it "works! (now write some real specs)" do
        profile = create :profile
        support = profile.supports.create! valid_attributes
        delete profile_support_path(profile, support)
        expect(response).to redirect_to(profile)
      end
    end
  end
end
