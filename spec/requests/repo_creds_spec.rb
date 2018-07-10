require 'rails_helper'
require 'support/sign_in_support'

RSpec.describe 'RepoCreds', type: :request do
  describe 'DELETE /repo/:repo_id/repo_cred/:id' do
    context 'with valid params' do
      let(:valid_attributes) {
        FactoryBot.build(:repo_cred).attributes
      }

      it 'works! (now write some real specs)' do
        sign_in_as_a_valid_user
        repo = create :repo, created_by: @user
        repo_cred = repo.repo_creds.create! valid_attributes
        delete repo_repo_cred_path(repo, repo_cred)
        expect(response).to redirect_to(repo)
      end
    end
  end
end
