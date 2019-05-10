class CirclesController < ApplicationController
  authorize_resource
  protect_from_forgery
  before_action :set_circle, only: [:show, :edit, :update, :destroy,
                                    :members, :remove_member, :owners,
                                    :remove_owner, :evaluations, :remove_evaluation,
                                    :profiles, :remove_profile]

  # GET /circles
  # GET /circles.json
  def index
    @circles = Circle.all
  end

  # GET /circles/1
  # GET /circles/1.json
  def show
    @recents = @circle.recents
  end

  # GET /circles/new
  def new
    @circle = Circle.new
  end

  # GET /circles/1/edit
  def edit
  end

  # POST /circles
  # POST /circles.json
  def create
    @circle = Circle.new(circle_params)
    current_user.add_role(:owner, @circle)
    respond_to do |format|
      if @circle.save
        format.html { redirect_to @circle, notice: 'Circle was successfully created.' }
        format.json { render :show, status: :created, location: @circle }
      else
        format.html { render :new }
        format.json { render json: @circle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /circles/1
  # PATCH/PUT /circles/1.json
  def update
    respond_to do |format|
      if @circle.update(circle_params)
        format.html { redirect_to @circle, notice: 'Circle was successfully updated.' }
        format.json { render :show, status: :ok, location: @circle }
      else
        format.html { render :edit }
        format.json { render json: @circle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /circles/1
  # DELETE /circles/1.json
  def destroy
    @circle.destroy
    respond_to do |format|
      format.html { redirect_to circles_url, notice: 'Circle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def members
    if (user = User.find(params[:user][:id]))
      user.add_role(:member, @circle) unless user.has_role?(:member, @circle)
    end
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def remove_member
    if (user = User.find(params[:user_id]))
      user.remove_role(:member, @circle) if user.has_role?(:member, @circle)
    end
    respond_to do |format|
      format.js { render 'members.js.erb', layout: false }
    end
  end

  def owners
    if (user = User.find(params[:user][:id]))
      user.add_role(:owner, @circle) unless user.has_role?(:owner, @circle)
    end
    respond_to do |format|
      format.js { render 'members.js.erb', layout: false }
    end
  end

  def remove_owner
    if (user = User.find(params[:user_id]))
      user.remove_role(:owner, @circle) if user.has_role?(:owner, @circle)
    end
    respond_to do |format|
      format.js { render 'members.js.erb', layout: false }
    end
  end

  def evaluations
    if (evaluation = Evaluation.find(params[:evaluation][:id]))
      @circle.evaluations << evaluation
    end
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def remove_evaluation
    if (evaluation = @circle.evaluations.find(params[:evaluation_id]))
      @circle.evaluations.delete(evaluation)
    end
    respond_to do |format|
      format.js { render 'evaluations.js.erb', layout: false }
    end
  end

  def profiles
    if (profile = Profile.find(params[:profile][:id]))
      @circle.profiles << profile
    end
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def remove_profile
    if (profile = @circle.profiles.find(params[:profile_id]))
      @circle.profiles.delete(profile)
    end
    respond_to do |format|
      format.js { render 'profiles.js.erb', layout: false }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_circle
    @circle = Circle.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def circle_params
    params.require(:circle).permit(:name)
  end
end
