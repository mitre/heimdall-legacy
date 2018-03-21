require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Repos', type: :request do
  describe 'GET /repos' do
    it 'works! (now write some real specs)' do
      sign_in_as_a_valid_user
      get repos_path
      expect(response).to have_http_status(200)
    end
  end
end
