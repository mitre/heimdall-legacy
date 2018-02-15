class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy, :ssp, :nist_800_53]
  protect_from_forgery except: [:create]

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
    data = params.to_unsafe_h()
    eval_json = {"version": data[:version], "controls": data[:controls], "other_checks": data[:other_checks],
      "profiles": data[:profiles], "platform": data[:platform], "statistics": data[:statistics]}

    respond_to do |format|
      if @evaluation = Evaluation.parse(eval_json)
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully created.' }
        format.json { render :show, status: :created, location: @evaluation }
      else
        format.html { render :new }
        format.json { render json: "Evaluation creation failed", status: :unprocessable_entity }
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

  # GET /profiles/1
  # GET /profiles/1.json
  def ssp
    unless @@nist_800_53_json
      file = File.read("#{Rails.root}/data/nist_800_53.json")
      @@nist_800_53_json = JSON.parse(file)
    end
    @nist_hash = @@nist_800_53_json.deep_dup
    @profiles = @evaluation.profiles
    @counts, @controls = @evaluation.status_counts
    @symbols = {}
    @controls.each do |control_id, hsh|
      control = hsh[:control]
      @symbols[control.control_id] = hsh[:status_symbol]
    end
    @profiles.each do |profile|
      families, nist = profile.control_families
      logger.debug "Families: #{families}"
      @nist_hash["children"].each do |cf|
        family_value = 0
        cf["children"].each do |control|
          logger.debug "Check #{control["name"]}"
          if families.include?(control["name"])
            control["controls"] = nist[control["name"]]
            control["value"] = control["controls"].size
            family_value += control["controls"].size
          else
            control["value"] = 0
          end
        end
        cf["value"] = family_value
      end
    end
    #logger.debug "nist_hash: #{@nist_hash}"
    logger.debug "@symbols: #{@symbols}"
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
    if @evaluation = Evaluation.parse(JSON.parse(file.read))
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

end
