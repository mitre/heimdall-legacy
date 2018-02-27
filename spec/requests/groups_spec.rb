require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /profile/:profile_id/group/:id" do
    context "with valid params" do
      let(:valid_attributes) {
        FactoryGirl.build(:group).attributes
      }

      it "works! (now write some real specs)" do
        profile = create :profile
        group = profile.groups.create! valid_attributes
        get profile_group_path(profile, group)
        expect(response).to have_http_status(200)
      end
    end
  end
end
