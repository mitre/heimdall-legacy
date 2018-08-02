class EvaluationsController < ApplicationController
  load_resource
  authorize_resource only: [:show, :destroy, :upload, :filter, :clear_filter]
  protect_from_forgery except: [:upload_api]

  # GET /evaluations
  # GET /evaluations.json
  def index
    if current_user
      @evaluations = current_user.readable_evaluations
    else
      @circle = Circle.where(name: 'Public').try(:first)
      @evaluations = @circle.present? ? @circle.evaluations : []
    end
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
    @profiles = @evaluation.profiles
    filters, @filter_label = session_filters
    @counts, @controls = @evaluation.status_counts(filters)
    @nist_hash = Constants::NIST_800_53
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
    @nist_hash = Constants::NIST_800_53
    @symbols = @evaluation.symbols
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
    filters, = session_filters
    category = nil
    category = params[:category].downcase if params.key?(:category)
    status_sym = nil
    status_sym = params[:status_symbol].downcase.tr(' ', '_').to_sym if params.key?(:status_symbol)
    @control_hash = @evaluation.nist_hash category, status_sym, filters
    @name = Constants::NIST_800_53['name']
    @families = Constants::NIST_800_53['children']
  end

  def clear_filter
    session[:filter] = nil
    session[:filter_group] = nil
    redirect_to @evaluation
  end

  def filter
    f_params = params[:filter]
    @filter = Filter.valid_filter f_params
    if f_params[:save_filter]
      @filter.save
    end
    session[:filter] = @filter
    session[:filter_group] = nil
    redirect_to @evaluation
  end

  def filter_select
    filter_params = params[:filter_group]
    if filter_params[:id].present?
      @filter_group = FilterGroup.find(filter_params[:id])
      session[:filter] = nil
      session[:filter_group] = @filter_group
    elsif filter_params[:filter_ids].present?
      @filter = Filter.find(filter_params[:filter_ids])
      session[:filter_group] = nil
      session[:filter] = @filter
    end
    redirect_to @evaluation
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

  def upload_api
    file = params[:file]
    sign_in_api_user(params[:email], params[:api_key])
    if current_user
      authorize! :create, Evaluation
      if (@eval = Evaluation.parse(JSON.parse(file.read)))
        @eval.force_created_by(current_user)
        @evaluation = Evaluation.find(@eval.id)
        render body: 'SUCCESS: Evaluation uploaded'
      else
        render body: 'ERROR: Could not upload evaluation'
      end
    else
      render body: 'ERROR: Could not login User'
    end
  end

  def compare
    if params[:evaluation] && params[:evaluation][:eval_ids]
      eval_params = params[:evaluation][:eval_ids]
      @evaluations = []
      @compare_hsh = {}
      eval_params.each do |eval_id|
        evaluation = Evaluation.find(eval_id)
        @evaluations << evaluation
        _, controls = evaluation.status_counts
        controls.each do |_, hsh|
          control = hsh[:control]
          unless @compare_hsh.key?(control.control_id)
            @compare_hsh[control.control_id] = {}
          end
          @compare_hsh[control.control_id][evaluation.id] = hsh
        end
      end
    else
      redirect_to evaluations_url
    end
  end

  private

  def sign_in_api_user(email, api_key)
    if (user = User.where(email: email, api_key: api_key).first)
      sign_in user
      if user._type == 'DbUser'
        session['user_id'] = session['warden.user.db_user.key'].first.try(:first)
      elsif user._type == 'LdapUser'
        session['user_id'] = session['warden.user.ldap_user.key'].first.try(:first)
      end
    end
  end

  def session_filters
    filters = nil
    filter_label = nil
    if session[:filter]
      filter = session[:filter].is_a?(Filter) ? session[:filter] : Filter.new(session[:filter])
      filters = [filter]
      filter_label = filter.to_s
    elsif session[:filter_group]
      filter_group = session[:filter_group].is_a?(FilterGroup) ? session[:filter_group] : FilterGroup.new(session[:filter_group])
      filters = filter_group.filters
      filter_label = "#{filter_group.name}: #{filter_group.filters.map(&:to_s).join(', ')}"
    end
    [filters, filter_label]
  end
end
