class InputsController < ApplicationController
  before_action :set_input, only: [:show]

  def show
    authorize! :read, @profile
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_input
    @profile = Profile.find(params[:profile_id])
    @input = @profile.inputs.find(params[:id])
  end
end
