require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Circles', type: :request do
  describe 'GET /circles' do
    it 'should be valid' do
      sign_in_as_a_valid_user
      circle = create :circle, created_by: @user
      get circle_path(circle)
      expect(response).to have_http_status(200)
    end
  end
end
