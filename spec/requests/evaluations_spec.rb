require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Evaluations', type: :request do
  describe 'GET /evaluations' do
    it 'works! (now write some real specs)' do
      get evaluations_path
      expect(response).to have_http_status(200)
    end
  end
end
