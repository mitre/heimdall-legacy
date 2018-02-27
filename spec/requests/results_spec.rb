require 'rails_helper'

RSpec.describe "Results", type: :request do
  describe "GET /evalution/:evaluation_id/result/:id" do
    context "with valid params" do
      let(:valid_attributes) {
        FactoryGirl.build(:result).attributes
      }

      it "works! (now write some real specs)" do
        evaluation = create :evaluation
        result = evaluation.results.create! valid_attributes
        get evaluation_result_path(evaluation, result)
        expect(response).to have_http_status(200)
      end
    end
  end
end
