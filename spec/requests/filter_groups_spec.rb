require 'rails_helper'

RSpec.describe 'FilterGroups', type: :request do
  describe 'GET /filter_groups' do
    it 'works! (now write some real specs)' do
      sign_in_as_a_valid_user
      filter_group = create :filter_group, created_by: @user
      get filter_group_path(filter_group)
      expect(response).to have_http_status(200)
    end
  end
end
