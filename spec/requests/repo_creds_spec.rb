require 'rails_helper'

RSpec.describe "RepoCreds", type: :request do
  describe "GET /repo_creds" do
    it "works! (now write some real specs)" do
      get repo_creds_path
      expect(response).to have_http_status(200)
    end
  end
end
