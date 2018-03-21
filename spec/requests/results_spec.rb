require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Results', type: :request do
  describe 'GET /evalution/:evaluation_id/result/:id' do
    context 'with valid params' do

      before(:each) do
        sign_in_as_a_valid_user
        @evaluation = create :evaluation, created_by: @user
        @profile = create :profile, created_by: @user
        @control = create :control, profile_id: @profile.id, created_by: @user
      end

      it 'works! (now write some real specs)' do
        result = create :result, evaluation_id: @evaluation.id, control_id: @control.id, created_by: @user
        get evaluation_result_path(@evaluation, result)
        expect(response).to have_http_status(200)
      end
    end
  end
end
