class GroupsController < ApplicationController
  before_action :set_group, only: [:show]

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize! :read, @profile
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @profile = Profile.find(params[:profile_id])
    @group = @profile.groups.find(params[:id])
  end
end
