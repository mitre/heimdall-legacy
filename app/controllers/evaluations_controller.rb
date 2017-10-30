class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

  # GET /evaluations
  # GET /evaluations.json
  def index
    @evaluations = Evaluation.all
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
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
    @evaluation = Evaluation.create(transform(JSON.parse(file.read)))
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
