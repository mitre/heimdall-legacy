require 'rails_helper'

RSpec.describe "Depends", type: :request do
  describe "GET /depends" do
    it "works! (now write some real specs)" do
      get depends_path
      expect(response).to have_http_status(200)
    end
  end
end
