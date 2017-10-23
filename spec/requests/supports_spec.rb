require 'rails_helper'

RSpec.describe "Supports", type: :request do
  describe "GET /supports" do
    it "works! (now write some real specs)" do
      get supports_path
      expect(response).to have_http_status(200)
    end
  end
end
