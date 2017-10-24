class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.find(params[:profile_id])
    @profile = Profile.new
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
        format.html { render :new }
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
        format.html { render :edit }
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

  def upload
    file = params[:file]
    @profile = Profile.create(transform(JSON.parse(file.read)))
    redirect_to @profile
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:id, :name, :title, :maintainer, :copyright, :copyright_email, :license, :summary, :version, :sha256, :depends, :supports, :controls, :groups, :profile_attributes)
    end

    #convert parameters with hyphen to parameters with underscore and rename 'attributes'
    def transform hash
      #logger.debug("OLD HASH: #{hash.inspect}")
      hash["controls"].each do |control|
        tags = control.delete('tags')
        logger.debug("TAGS: #{tags.inspect}")
        tags.each do |key, value|
          logger.debug("key: #{key}, value:#{value}")
          control["tag_#{key}"] = value
        end
        source_location = control.delete('source_location')
        sl = source_location.each do |key, value|
          control["sl_#{key}"] = value
        end
      end
      hash['attributes'].each do |attr|
        options = attr.delete('options')
        options.each do |key, value|
          if key == "default"
            unless value.kind_of?(Array)
              unless value.kind_of?(String)
                value = "#{value}"
              end
              value = [value]
            end
          end
          attr["option_#{key}"] = value
        end
      end
      #logger.debug("NEW HASH: #{hash.inspect}")
      hash.deep_transform_keys{ |key| key.to_s.tr('-', '_').gsub('attributes', 'profile_attributes').gsub(/\bid\b/, 'control_id') }
    end
end
