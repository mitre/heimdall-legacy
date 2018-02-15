require 'rails_helper'

RSpec.describe "Repos", type: :request do
  describe "GET /repos" do
    it "works! (now write some real specs)" do
      get repos_path
      expect(response).to have_http_status(200)
    end
  end
end
