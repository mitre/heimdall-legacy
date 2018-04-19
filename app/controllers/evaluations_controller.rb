class EvaluationsController < ApplicationController
  load_resource
  authorize_resource only: [:show, :destroy, :filter]
  protect_from_forgery

  # GET /evaluations
  # GET /evaluations.json
  def index
    @evaluations = Evaluation.all
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
    logger.debug "params: #{params.inspect}"
    @profiles = @evaluation.profiles
    @counts, @controls = @evaluation.status_counts
    @nist_hash = ProfilesController.nist_800_53
    respond_to do |format|
      format.html { render :show }
      format.json { render :show }
      format.ckl { render :show, layout: false }
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
    authorize! :read, Evaluation
    @nist_hash = ProfilesController.nist_800_53
    @symbols = @evaluation.symbols
    # @counts, @controls = @evaluation.status_counts
    @evaluation.profiles.each do |profile|
      families, nist = profile.control_families
      next if families.empty?
      @nist_hash['children'].each do |cf|
        family_value = 0
        cf['children'].each do |control|
          if families.include?(control['name'])
            control['controls'] = nist[control['name']]
            control['value'] = control['controls'].size
            family_value += control['controls'].size
          else
            control['value'] = 0
          end
        end
        cf['value'] = family_value
      end
    end
  end

  def nist
    authorize! :read, Evaluation
    category = nil
    category = params[:category].downcase if params.key?(:category)
    status_sym = nil
    status_sym = params[:status_symbol].downcase.tr(' ', '_').to_sym if params.key?(:status_symbol)
    @control_hash = @evaluation.nist_hash category, status_sym
    nist_hash = ProfilesController.nist_800_53
    @name = nist_hash['name']
    @families = nist_hash['children']
  end

  def upload
    authorize! :create, Evaluation
    file = params[:file]
    if (@eval = Evaluation.parse(JSON.parse(file.read)))
      @evaluation = Evaluation.find(@eval.id)
      redirect_to @evaluation, notice: 'Evaluation uploaded.'
    else
      redirect_to evaluations_url, notice: 'File does not contain an evaluation.'
    end
  end
end
