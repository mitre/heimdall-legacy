class SupportsController < ApplicationController
  before_action :transform
  before_action :set_profile, only: [:create, :destroy]

  # POST /profiles/:profile_id/supports
  # POST /profiles/:profile_id/supports.json
  def create
    authorize! :create, @profile
    respond_to do |format|
      begin
        @profile.supports.create!(support_params)
        format.html { redirect_to edit_profile_path(@profile), notice: 'Support was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      rescue Mongoid::Errors::Validations
        format.html { redirect_to edit_profile_path(@profile), error: 'Support was not successfully created.' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/:profile_id/supports/1
  # DELETE /profiles/:profile_id/supports/1.json
  def destroy
    authorize! :destroy, @profile
    @support = @profile.supports.find(params[:id])
    @support.destroy
    respond_to do |format|
      format.html { redirect_to edit_profile_path(@profile), notice: 'Support was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def support_params
    params.require(:support).permit(:os_family)
  end

  # convert parameters with hyphen to parameters with underscore.
  def transform
    params.transform_keys! { |key| key.tr('-', '_') }
  end
end
