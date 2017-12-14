class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy, :nist_800_53]

  @@nist_800_53_json = nil

  # GET /evaluations
  # GET /evaluations.json
  def index
    @evaluations = Evaluation.all
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
    @profiles = @evaluation.profiles
    @counts, @controls = @evaluation.status_counts
    #logger.debug "CONTROL: #{@controls.first.inspect}"
    #@controls = @evaluation.controls
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @evaluation}
    end
  end

  # GET /evaluations/new
  def new
    @evaluation = Evaluation.new
  end

  # GET /evaluations/1/edit
  def edit
  end

  # POST /evaluations
  # POST /evaluations.json
  def create
    @evaluation = Evaluation.new(evaluation_params)

    respond_to do |format|
      if @evaluation.save
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully created.' }
        format.json { render :show, status: :created, location: @evaluation }
      else
        format.html { render :new }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluations/1
  # PATCH/PUT /evaluations/1.json
  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully updated.' }
        format.json { render :show, status: :ok, location: @evaluation }
      else
        format.html { render :edit }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluations/1
  # DELETE /evaluations/1.json
  def destroy
    @evaluation.destroy
    respond_to do |format|
      format.html { redirect_to evaluations_url, notice: 'Evaluation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def nist_800_53
    category = nil
    category = params[:category].downcase if params.has_key?(:category)
    status_sym = nil
    status_sym = params[:status_symbol].downcase.tr(' ', '_').to_sym if params.has_key?(:status_symbol)
    unless @@nist_800_53_json
      file = File.read("#{Rails.root}/data/nist_800_53.json")
      @@nist_800_53_json = JSON.parse(file)
    end
    nist_hash = @evaluation.nist_hash category, status_sym
    #logger.debug "nist_hash: #{nist_hash.inspect}"
    new_hash = @@nist_800_53_json.deep_dup
    total_impact = 0
    total_children = 0
    new_hash["children"].each do |cf|
      cf_total_impact = 0.0
      cf_total_children = 0
      cf["children"].each do |control|
        control_total_impact = 0.0
        control_total_children = 0
        if nist_hash[control["name"]]
          control.delete('value')
          control["children"] = nist_hash[control["name"]]
          control["children"].each do |childt|
            #logger.debug "CHILD #{childt.inspect}"
            child = childt[:children].first
            if child[:status_value]
              if child[:status_value] > 0.4
                if control_total_impact < 0.6
                  control_total_children = 1
                  control_total_impact = child[:status_value]
                else
                  control_total_children += 1
                  control_total_impact += child[:status_value]
                end
                if child[:status_value] > 0.6
                  control_total_children += 4
                  control_total_impact += 4 * child[:status_value]
                end
                #logger.debug "#{control['name']}: #{child[:status_value]}, cont_impact: #{control_total_impact}, cont_children: #{control_total_children}"
              elsif control_total_impact < 0.6
                control_total_impact = 0.4
                control_total_children = 1
                #logger.debug "#{control['name']}: #{child[:status_value]}, cont_impact: #{control_total_impact}, cont_children: #{control_total_children}"
              end
            end
          end
        end
        #logger.debug "SET #{control['name']} status_value: #{control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children}"
        control["status_value"] = control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children
        cf_total_impact += control_total_impact
        cf_total_children += control_total_children
        #logger.debug "#{cf['name']} cft_status_value: #{cf_total_impact}, cft_children: #{cf_total_children}"
      end
      #logger.debug "SET #{cf['name']} status_value: #{cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children}"
      cf["status_value"] = cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children
      total_impact += cf_total_impact
      total_children += cf_total_children
    end
    new_hash["status_value"] = total_impact == 0.0 ? 0.0 : total_impact/total_children
    #logger.debug "new_hash: #{new_hash.inspect}"
    render json: new_hash
  end

  def upload
    file = params[:file]
    contents = JSON.parse(file.read)
    if contents.key? "profiles"
      hash = transform(contents)
      results = hash.delete('results')
      profiles = hash.delete('profiles')
      @evaluation = Evaluation.create(hash)
      logger.debug("New Evaluation: #{@evaluation.inspect}")
      results.each do |result|
        logger.debug("Add result to evalution")
        @evaluation.results << result
      end
      logger.debug("Results: #{@evaluation.results.size}")
      profiles.each do |profile|
        logger.debug("Add profile to evalution")
        @evaluation.profiles << profile
      end
      logger.debug("Profiles: #{@evaluation.profiles.size}")
      redirect_to @evaluation, notice: 'Evaluation uploaded.'
    else
      redirect_to evaluations_url, notice: 'File does not contain an evaluation.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_params
      params.require(:evaluation).permit(:version, :other_checks, :platform_name, :platform_release, :statistics_duration)
    end

    #convert parameters with hyphen to parameters with underscore and rename 'attributes'
    def transform hash
      hash.deep_transform_keys!{ |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'profile_attributes').gsub(/\bid\b/, 'control_id') }
      hash.delete('controls')
      platform = hash.delete('platform')
      platform.try(:each) do |key, value|
        hash["platform_#{key}"] = value
      end
      statistics = hash.delete('statistics')
      statistics.try(:each) do |key, value|
        hash["statistics_#{key}"] = value
      end
      results = []
      all_profiles = []
      profiles = hash.delete('profiles')
      profiles.try(:each) do |profile_hash|
        profile = Profile.find_by(:sha256 => profile_hash['sha256'])
        unless profile
          new_profile_hash, controls = Profile.transform(profile_hash.deep_dup)
          profile = Profile.create(new_profile_hash)
          controls.each do |control|
            logger.debug "Add Control: #{control.keys}"
            profile.controls.create(control)
          end
        end
        logger.debug "Add RESULTS"
        profile_hash['controls'].try(:each) do |control_hash|
          logger.debug "For #{control_hash['control_id']}"
          if control = profile.controls.find_by(:control_id => control_hash['control_id'])
            logger.debug "Found Control"
            control_hash['results'].try(:each) do |result|
              logger.debug "For result #{result.inspect}"
              control.results.create(result)
            end
            results.concat control.results
          end
          logger.debug "Results: #{results.size}"
        end
        all_profiles << profile
      end
      hash['results'] = results
      hash['profiles'] = all_profiles
      logger.debug("hash: #{hash.inspect}")
      hash
    end
end
