class AspectsController < ApplicationController
  before_action :set_aspect, only: [:show]

  def show
    authorize! :read, @profile
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aspect
    @profile = Profile.find(params[:profile_id])
    @aspect = @profile.aspects.find(params[:id])
  end
end
