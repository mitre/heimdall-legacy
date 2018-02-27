class DependsController < ApplicationController
  before_action :set_profile, only: [:create, :destroy]

  # POST /profiles/:profile_id/depends
  # POST /profiles/:profile_id/depends.json
  def create
    @depend = @profile.depends.new(depend_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Dependency was successfully created.' }
        format.json { render :show, status: :created, location: @depend }
      else
        format.html { redirect_to @profile, error: 'Dependency was not successfully created.' }
        format.json { render json: @depend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/:profile_id/depends/1
  # DELETE /profiles/:profile_id/depends/1.json
  def destroy
    @depend = @profile.depends.find(params[:id])
    @depend.destroy
    respond_to do |format|
      format.html { redirect_to @profile, notice: 'Depend was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:profile_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def depend_params
      params.require(:depend).permit(:name, :path)
    end
end
