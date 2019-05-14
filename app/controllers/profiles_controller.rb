class ProfilesController < ApplicationController
  load_resource
  authorize_resource only: [:show, :edit, :destroy, :upload]

  # GET /profiles
  # GET /profiles.json
  def index
    if current_user
      @profiles = current_user.readable_profiles
    else
      @circle = Circle.where(name: 'Public').try(:first)
      @profiles = @circle.present? ? @circle.readable_profiles : []
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    # respond_to do |format|
    #   format.html { render :show }
    #   format.json { render json: @profile.to_json}
    # end
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { redirect_to profiles_url, error: 'Profile was not successfully created.' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, error: 'Profile was not successfully updated.' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def nist
    authorize! :read, Profile
    category = nil
    category = params[:category].downcase if params.key?(:category)
    @control_hash = @profile.nist_hash category
    nist_hash = Constants::NIST_800_53
    @name = nist_hash['name']
    @families = nist_hash['children']
  end

  def upload
    authorize! :create, Profile
    file = params[:file]
    contents = JSON.parse(file.read)
    if contents.key? 'name'
      profile_hash = Profile.transform(contents)
      begin
        #groups = profile_hash.delete(:groups_attributes)
        #controls = profile_hash.delete(:controls_attributes)
        profile_hash['created_by_id'] = current_user.id
        Rails.logger.debug "Profile Hash keys: #{profile_hash.keys}"
        @profile = Profile.new(profile_hash)
        Rails.logger.debug "New Profile: #{@profile.inspect}"
        if @profile.save
          Rails.logger.debug "Save profile"
          #controls.each do |control_hash|
          #  control = @profile.controls.create(control_hash)
          #  if control.errors.present?
          #    Rails.logger.debug "Control error: #{control.errors.inspect}"
          #  end
          #end
          #groups.each do |group_hash|
          #  Rails.logger.debug "Create Group #{group_hash}"
          #  controls = group_hash.delete('controls')
          #  group = @profile.groups.create(group_hash)
          #  Rails.logger.debug "Created Group #{group.inspect}"
          #  controls.each do |control_id|
          #    control = @profile.controls.where(control_id: control_id).first
          #    group.controls << control if control.errors.empty?
          #  end
          #end
          redirect_to @profile, notice: 'Profile uploaded.'
        else
          logger.debug "ERROR #{@profile.errors.inspect}"
          redirect_to profiles_url, error: 'Profile was not successfully created.'
        end
      rescue Exception => e
        logger.debug "Import error: #{e.inspect}"
        redirect_to profiles_url, notice: 'Profile was malformed.'
      end
    else
      redirect_to profiles_url, notice: 'File does not contain a profile.'
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:id, :name, :title, :maintainer, :copyright, :copyright_email, :license, :summary, :version, :sha256, :supports, :controls, :groups, :aspects)
  end
end
