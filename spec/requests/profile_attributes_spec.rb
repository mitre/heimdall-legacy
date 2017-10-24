require 'rails_helper'

RSpec.describe "ProfileAttributes", type: :request do
  describe "GET /profile_attributes" do
    it "works! (now write some real specs)" do
      get profile_attributes_path
      expect(response).to have_http_status(200)
    end
  end
end
