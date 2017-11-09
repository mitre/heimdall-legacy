class SupportsController < ApplicationController
  before_action :transform
  before_action :set_support, only: [:show, :edit, :update, :destroy]

  # GET /supports
  # GET /supports.json
  def index
    @supports = Support.all
  end

  # GET /supports/1
  # GET /supports/1.json
  def show
  end

  # GET /supports/:profile_id/new/
  def new
    @profile = Profile.find(params[:profile_id])
    @support = @profile.supports.new()
  end

  # GET /supports/1/edit
  def edit
  end

  # POST /supports/:profile_id
  # POST /supports.json
  def create
    @profile = Profile.find(params[:profile_id])
    @support = @profile.supports.new(support_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Support was successfully created.' }
        format.json { render :show, status: :created, location: @support }
      else
        format.html { redirect_to @profile, error: 'Support was not successfully created.' }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supports/1
  # PATCH/PUT /supports/1.json
  def update
    respond_to do |format|
      if @support.update(support_params)
        format.html { redirect_to @support, notice: 'Support was successfully updated.' }
        format.json { render :show, status: :ok, location: @support }
      else
        format.html { render :edit }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supports/1
  # DELETE /supports/1.json
  def destroy
    @support.destroy
    respond_to do |format|
      format.html { redirect_to @profile, notice: 'Support was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support
      @profile = Profile.find(params[:profile_id])
      @support = @profile.supports.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def support_params
      params.require(:support).permit(:os_family)
    end

    #convert parameters with hyphen to parameters with underscore.
    def transform
      params.transform_keys! { |key| key.tr('-', '_') }
    end
end
