require 'rails_helper'

RSpec.describe "Depends", type: :request do
  describe "DELETE /profile/:profile_id/depend/:id" do
    context "with valid params" do
      let(:valid_attributes) {
        FactoryGirl.build(:dependency).attributes
      }

      it "works! (now write some real specs)" do
        profile = create :profile
        depend = profile.depends.create! valid_attributes
        delete profile_depend_path(profile, depend)
        expect(response).to redirect_to(profile)
      end
    end
  end
end
