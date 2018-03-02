class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy, :add, :remove]

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize! :read, @profile
  end

  # GET /groups/:profile_id/new
  def new
    @profile = Profile.find(params[:profile_id])
    authorize! :create, @profile
    @group = @profile.groups.new
  end

  # POST /groups
  # POST /groups.json
  def create
    @profile = Profile.find(params[:profile_id])
    authorize! :create, @profile
    @group = @profile.groups.new(group_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_group_url(@profile, @group), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { redirect_to @profile, error: 'Group was not successfully created.' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize! :update, @profile
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to profile_group_url(@profile, @group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { redirect_to profile_group_url(@profile, @group), error: 'Error updating Group' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def add
    authorize! :update, @profile
    @group.controls << group_params[:controls]
    logger.debug "add group_params: #{group_params.inspect}"
    respond_to do |format|
      if @group.save
        format.html { redirect_to profile_group_url(@profile, @group), notice: 'Control was added to Group' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { redirect_to profile_group_url(@profile, @group), error: 'Error updating Group' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def remove
    authorize! :update, @profile
    logger.debug "delete remove_params: #{remove_params.inspect}"
    control_id = remove_params[:control_id]
    logger.debug "delete #{control_id}"
    @group.controls.delete(control_id)
    respond_to do |format|
      if @group.save
        format.html { redirect_to profile_group_url(@profile, @group), notice: 'Control was deleted from Group' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { redirect_to profile_group_url(@profile, @group), error: 'Error updating Group' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    authorize! :destroy, @profile
    @group.destroy
    respond_to do |format|
      format.html { redirect_to @profile, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @profile = Profile.find(params[:profile_id])
      @group = @profile.groups.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:title, :controls, :controls_list, :control_id)
    end

    def remove_params
      params.permit(:profile_id, :id, :control_id)
    end
end
