class ProfilesController < ApplicationController
  load_resource
  authorize_resource only: [:show, :details, :results, :destroy, :upload]

  # GET /profiles
  # GET /profiles.json
  def index
    if current_user
      @profiles = current_user.readable_profiles
    else
      @circle = Circle.where(name: 'Public').try(:first)
      @profiles = @circle.present? ? @circle.readable_profiles : []
    end
    @eval_counts = Profile.evaluation_counts
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @profile.profile_json }
    end
  end

  def details
  end

  def results
    logger.debug "@profile: #{@profile.inspect}"
    respond_to do |format|
      format.js { render layout: false }
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
    category = convert_impact(params[:category]) if params.key?(:category)
    @control_hash = @profile.nist_hash category
    nist_hash = Constants::NIST_800_53
    @name = nist_hash['name']
    @families = nist_hash['children']
  end

  def upload
    authorize! :create, Profile
    file = params[:file]
    contents = JSON.parse(file.read)
    if contents.key? 'sha256'
      profile = Profile.where(sha256: contents['sha256']).first
      if profile.present?
        Rails.logger.debug "Profile already exists"
        redirect_to profiles_url, error: 'Profile already exists.'
      else
        profile_hash = Profile.transform(contents, nil)
        begin
          profile_hash['created_by_id'] = current_user.id
          @profile = Profile.new(profile_hash)
          if @profile.save
            Rails.logger.debug "Profile saved"
            redirect_to @profile, notice: 'Profile uploaded.'
          else
            Rails.logger.debug "Saving error: #{@profile.errors.inspect}"
            redirect_to profiles_url, error: 'Profile was not successfully created.'
          end
        rescue Exception
          Rails.logger.debug "Profile was malformed"
          redirect_to profiles_url, notice: 'Profile was malformed.'
        end
      end
    else
      Rails.logger.debug "File does not contain a profile"
      redirect_to profiles_url, notice: 'File does not contain a profile.'
    end
  end

  private

  def convert_impact(impact)
    if impact == 'None'
      0.0
    elsif impact == 'Low'
      0.3
    elsif impact == 'Medium'
      0.5
    elsif impact == 'High'
      0.7
    elsif impact == 'Critical'
      1.0
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:id, :name, :title, :maintainer, :copyright, :copyright_email, :license, :summary, :version, :sha256, :supports, :controls, :groups, :aspects)
  end
end
