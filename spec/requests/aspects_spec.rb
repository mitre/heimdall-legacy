require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'Aspects', type: :request do
  describe 'GET /profile/:profile_id/aspect/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:aspect).attributes
      }

    end
  end
end
