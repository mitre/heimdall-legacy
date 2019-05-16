require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Controls', type: :request do
  context 'Editor is logged in' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      sign_in_as_a_valid_user
    end

    before(:each) do
      @profile = create :profile, created_by: @user
    end

    describe 'GET /controls' do
      it 'works! (now write some real specs)' do
        control = create :control, profile_id: @profile.id, created_by: @user
        get profile_control_path(control.profile_id, control)
        expect(response).to have_http_status(200)
      end
    end
  end
end
