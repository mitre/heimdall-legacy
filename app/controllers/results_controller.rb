class ResultsController < ApplicationController
  authorize_resource
  before_action :set_eval, only: [:show, :index]

  # GET /results
  # GET /results.json
  def index
    @results = @evaluation.results
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = @evaluation.results.find(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_eval
    @evaluation = Evaluation.find(params[:evaluation_id])
  end
end
