class ProfileAttributesController < ApplicationController
  before_action :set_profile_attribute, only: [:show, :edit, :update, :destroy]

  # GET /profile_attributes/1
  # GET /profile_attributes/1.json
  def show
    authorize! :read, @profile
  end

  # GET /profile_attributes/:profile_id/new
  def new
    @profile = Profile.find(params[:profile_id])
    authorize! :create, @profile
    @profile_attribute = @profile.profile_attributes.new
  end

  # GET /profile_attributes/1/edit
  def edit
    authorize! :edit, @profile
  end

  # POST /profile_attributes
  # POST /profile_attributes.json
  def create
    @profile = Profile.find(params[:profile_id])
    authorize! :create, @profile
    respond_to do |format|
      begin
        @profile.profile_attributes.create!(profile_attribute_params)
        format.html { redirect_to edit_profile_path(@profile), notice: 'Attribute was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      rescue Mongoid::Errors::Validations
        format.html { redirect_to edit_profile_path(@profile), error: 'Attribute was not successfully created.' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_attributes/1
  # PATCH/PUT /profile_attributes/1.json
  def update
    authorize! :update, @profile
    respond_to do |format|
      if @profile_attribute.update(profile_attribute_params)
        format.html { redirect_to edit_profile_path(@profile), notice: 'Attribute was successfully updated.' }
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
    authorize! :destroy, @profile
    @profile_attribute.destroy
    respond_to do |format|
      format.html { redirect_to edit_profile_path(@profile), notice: 'Attribute was successfully destroyed.' }
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
