require 'rails_helper'

RSpec.describe 'Filters', type: :request do
  describe 'GET /filters' do
    it 'should be valid' do
      sign_in_as_a_valid_user
      filter = create :filter, created_by: @user
      get filter_path(filter)
      expect(response).to have_http_status(200)
    end
  end
end
