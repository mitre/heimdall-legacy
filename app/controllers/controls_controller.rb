class ControlsController < ApplicationController
  before_action :set_control, only: [:show, :details]

  # GET /controls/1
  # GET /controls/1.json
  def show
  end

  def details
    logger.debug "DETAILS for #{@control.control_id}"
    @evaluation = Evaluation.find(params[:evaluation_id]) if params.key?(:evaluation_id)
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_control
    @profile = Profile.find(params[:profile_id])
    @control = @profile.controls.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def control_params
    params.require(:control).permit(
      :id, :title, :desc, :impact, :refs, :refs_list,
      :code, :control_id, :profile_id,
      :tag_severity, :tag_gtitle, :tag_gid, :tag_rid, :tag_stig_id,
      :tag_cci, :tag_nist, :tag_nist_list,
      :tag_subsystems, :tag_subsystems_list, :tag_check, :tag_fix,
      :sl_ref, :sl_line
    )
  end
end
