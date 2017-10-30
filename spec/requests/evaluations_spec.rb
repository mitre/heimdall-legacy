require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  describe "GET /evaluations" do
    it "works! (now write some real specs)" do
      get evaluations_path
      expect(response).to have_http_status(200)
    end
  end
end
