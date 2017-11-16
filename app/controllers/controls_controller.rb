class ControlsController < ApplicationController
  before_action :set_control, only: [:show, :edit, :update, :destroy, :details]

  # GET /controls
  # GET /controls.json
  def index
    @controls = Control.all
  end

  # GET /controls/1
  # GET /controls/1.json
  def show
  end

  # GET /controls/:profile_id/new
  def new
    @profile = Profile.find(params[:profile_id])
    @control = @profile.controls.new()
  end

  # GET /controls/1/edit
  def edit
  end

  # POST /controls/:profile_id
  # POST /controls.json
  def create
    @profile = Profile.find(params[:profile_id])
    @control = @profile.controls.new(control_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Control was successfully created.' }
        format.json { render :show, status: :created, location: @control }
      else
        format.html { redirect_to @profile, error: 'Control was not successfully created.' }
        format.json { render json: @control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /controls/1
  # PATCH/PUT /controls/1.json
  def update
    respond_to do |format|
      if @control.update(control_params)
        format.html { redirect_to profile_control_url(@profile, @control), notice: 'Control was successfully updated.' }
        format.json { render :show, status: :ok, location: @control }
      else
        format.html { render :edit }
        format.json { render json: @control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controls/1
  # DELETE /controls/1.json
  def destroy
    @control.destroy
    respond_to do |format|
      format.html { redirect_to @profile, notice: 'Control was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def details
    logger.debug "DETAILS for #{@control.control_id}"
    respond_to do |format|
      logger.debug "RENDER JS"
      format.js {render layout: false}
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

    #convert parameters with hyphen to parameters with underscore and rename 'attributes'
    def transform hash
      hash.deep_transform_keys{ |key| key.to_s.tr('-', '_').gsub('id', 'control_id') }
    end

end
