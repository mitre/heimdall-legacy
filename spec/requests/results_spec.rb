require 'rails_helper'

RSpec.describe "Results", type: :request do
  describe "GET /results" do
    it "works! (now write some real specs)" do
      get results_path
      expect(response).to have_http_status(200)
    end
  end
end
