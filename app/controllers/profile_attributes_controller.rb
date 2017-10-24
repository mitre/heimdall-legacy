class ProfileAttributesController < ApplicationController
  before_action :set_profile_attribute, only: [:show, :edit, :update, :destroy]

  # GET /profile_attributes
  # GET /profile_attributes.json
  def index
    @profile_attributes = ProfileAttribute.all
  end

  # GET /profile_attributes/1
  # GET /profile_attributes/1.json
  def show
  end

  # GET /profile_attributes/:profile_id/new
  def new
    @profile = Profile.find(params[:profile_id])
    @profile_attribute = ProfileAttribute.new
  end

  # GET /profile_attributes/1/edit
  def edit
  end

  # POST /profile_attributes
  # POST /profile_attributes.json
  def create
    @profile = Profile.find(params[:profile_id])
    @profile_attribute = ProfileAttribute.new(profile_attribute_params)

    respond_to do |format|
      if @profile_attribute.save
        format.html { redirect_to @profile, notice: 'Attribute was successfully created.' }
        format.json { render :show, status: :created, location: @profile_attribute }
      else
        format.html { redirect_to @profile, error: 'Attribute was not successfully created.' }
        format.json { render json: @profile_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_attributes/1
  # PATCH/PUT /profile_attributes/1.json
  def update
    respond_to do |format|
      if @profile_attribute.update(profile_attribute_params)
        format.html { redirect_to profile_profile_attribute_url(@profile, @profile_attribute), notice: 'Attribute was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile_attribute }
      else
        format.html { render :edit }
        format.json { render json: @profile_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_attributes/1
  # DELETE /profile_attributes/1.json
  def destroy
    @profile_attribute.destroy
    respond_to do |format|
      format.html { redirect_to profile_attributes_url, notice: 'Attribute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_attribute
      @profile = Profile.find(params[:profile_id])
      @profile_attribute = @profile.profile_attributes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_attribute_params
      params.require(:profile_attribute).permit(:name, :option_description, :option_default, :option_default_list)
    end
end
