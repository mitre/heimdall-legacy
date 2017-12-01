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
    @controls = @evaluation.controls
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
    category = params[:category] if params.has_key?(:category)
    status_symbol = nil
    status_symbol = params[:status_symbol].downcase.tr(' ', '_').to_sym if params.has_key?(:status_symbol)
    unless @@nist_800_53_json
      file = File.read("#{Rails.root}/data/nist_800_53.json")
      @@nist_800_53_json = JSON.parse(file)
    end
    nist_hash = @evaluation.nist_hash category, status_symbol
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
          control["children"].each do |child|
            #logger.debug "CHILD #{child.inspect}"
            if child[:status_value]
              control_total_children += 1
              control_total_impact += child[:status_value]
            end
            #logger.debug "#{control['name']}: #{child['impact']}, cont_impact: #{control_total_impact}, cont_children: #{control_total_children}"
          end
        end
        #logger.debug "SET #{control['name']} impact: #{control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children}"
        control["status_value"] = control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children
        cf_total_impact += control_total_impact
        cf_total_children += control_total_children
        #logger.debug "#{cf['name']} cft_impact: #{cf_total_impact}, cft_children: #{cf_total_children}"
      end
      #logger.debug "SET #{cf['name']} impact: #{cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children}"
      cf["status_value"] = cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children
      total_impact += cf_total_impact
      total_children += cf_total_children
    end
    new_hash["status_value"] = total_impact == 0.0 ? 0.0 : total_impact/total_children
    #logger.debug "new_hash: #{new_hash.inspect}"
    render json: new_hash
  end

  def upload2
    file = params[:file]
    hash = transform(JSON.parse(file.read))
    @evaluation = Evaluation.create(:version => hash['version'], :other_checks => hash['other_checks'],
      :platform_name => hash['platform_name'], :platform_release => hash['platform_release'], :statistics_duration => hash['statistics_duration'])
    logger.debug("New Evaluation: #{@evaluation.inspect}")
    hash['profiles'].each do |profile_hash|
      if profile = Profile.find_by(:name => profile_hash['name'])
        logger.debug("Profile: #{profile.name}")
        @evaluation.profiles << profile
        @evaluation.save
        profile_hash['controls'].each do |control_hash|
          logger.debug("Control: #{control_hash['control_id']}")
          if control = profile.controls.find_by(:control_id => control_hash['control_id'])
            control_hash['results'].each do |result_hash|
              logger.debug("New Result: #{result_hash.inspect}")
              result = Result.create(result_hash.merge(:control_id => control.id, :evaluation_id => @evaluation.id))
              logger.debug("New Result: #{result.inspect}")
              logger.debug("Total Results: #{@evaluation.results.size}")
            end
          end
        end
        @evaluation.save
      end
    end
    redirect_to evaluations_url
  end

  def upload
    file = params[:file]
    hash = transform(JSON.parse(file.read))
    logger.debug("HASH: #{hash.inspect}")
    @evaluation = Evaluation.create(hash)
    logger.debug("New Evaluation: #{@evaluation.inspect}")
    logger.debug("Results: #{@evaluation.results.size}")
    redirect_to evaluations_url
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
      hash.deep_transform_keys!{ |key| key.to_s.tr('-', '_').gsub('attributes', 'profile_attributes').gsub(/\bid\b/, 'control_id') }
      hash.delete('controls')
      platform = hash.delete('platform')
      platform.each do |key, value|
        hash["platform_#{key}"] = value
      end
      statistics = hash.delete('statistics')
      statistics.each do |key, value|
        hash["statistics_#{key}"] = value
      end
      results = []
      profiles = hash.delete('profiles')
      profiles.each do |profile_hash|
        if profile = Profile.find_by(:name => profile_hash['name'])
          profile_hash['controls'].each do |control_hash|
            if control = profile.controls.find_by(:control_id => control_hash['control_id'])
              control_hash['results'].each do |result|
                result['profile_name'] = profile.name
                result['control_id'] = control_hash['control_id']
                results << result
              end
            end
          end
        end
      end
      hash['results'] = results
      logger.debug("hash: #{hash.inspect}")
      hash
    end
end
