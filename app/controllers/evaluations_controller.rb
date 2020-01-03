class EvaluationsController < ApplicationController
  load_resource
  authorize_resource only: [:show, :partition, :destroy, :upload, :filter, :clear_filter, :tag, :new_xccdf]
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
    @eval_counts = Profile.evaluation_counts
    @grouping = {}
    @grouping['singles'] = []
    @evaluations.each do |evaluation|
      key = evaluation.profiles.collect(&:id)
      if key.present?
        unless @grouping.key?(key.to_s)
          @grouping[key.to_s] = []
        end
        if @eval_counts[key.first] > 1
          @grouping[key.to_s] << evaluation
        else
          @grouping['singles'] << evaluation
        end
      else
        @grouping['singles'] << evaluation
      end
    end
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
    @profiles = @evaluation.profiles
    _, @filter_label = session_filters
    @nist_hash = Constants::NIST_800_53
    respond_to do |format|
      format.html { render :show }
      format.json { render :show }
      format.ckl { render :show, layout: false }
      format.csv { render :show, layout: false }
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

  def chart
    if params['chart_type']
      @chart_type = params['chart_type']
    else
      @chart_type = 'treemap'
    end
    respond_to do |format|
      format.js { render layout: false }
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
    category = convert_impact(params[:category]) if params.key?(:category)
    status_sym = nil
    status_sym = params[:status_symbol].downcase.tr(' ', '_').to_sym if params.key?(:status_symbol)
    ex_ids = params[:ex_ids]
    Rails.logger.debug "ex_ids: #{ex_ids}, class: #{ex_ids.class}"
    if ex_ids.nil?
      ex_ids = []
    else
      ex_ids = ex_ids.split(',').map(&:to_i)
    end
    Rails.logger.debug "ex_ids: #{ex_ids}"
    @control_hash = nil
    @control_hash, @controls = @evaluation.nist_hash category, status_sym, ex_ids, filters
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

  def tag
    name = tag_params['name']
    value = tag_params['value']
    @evaluation.tags.each do |tag|
      if tag.content['name'] == name
        tag.destroy
      end
    end
    @evaluation.tags.create(content: {'name': "#{name}", 'value': "#{value}"})
    redirect_to @evaluation
  end

  def upload
    authorize! :create, Evaluation
    file = params[:file]
    circle_id = params[:circle_id]
    if (@eval = Evaluation.parse(JSON.parse(file.read), current_user))
      @evaluation = Evaluation.find(@eval.id)
      Rails.logger.debug "Now start_time is #{@evaluation.start_time}"

      @evaluation.tags.create(content: {'name': 'filename', 'value': "#{params[:file].original_filename}"})
      (Constants::TAG_NAMES - ['Filename']).each do |tag|
        if params[tag.downcase].present?
          @evaluation.tags.create(content: {'name': "#{tag.downcase}", 'value': "#{params[tag.downcase]}"})
        end
      end

      if circle_id.present?
        @circle = Circle.find(circle_id)
        @circle.evaluations << @evaluation
        redirect_to @circle, notice: 'Evaluation uploaded.'
      else
        redirect_to evaluations_url, notice: 'Evaluation uploaded.'
      end
    else
      redirect_to evaluations_url, notice: 'File does not contain an evaluation.'
    end
  end

  def upload_api
    file = params[:file]
    sign_in_api_user(params[:email], params[:api_key])
    circle = params[:circle]
    if current_user
      if current_user.has_role?(:admin) or current_user.has_role?(:editor)
        if (@eval = Evaluation.parse(JSON.parse(file.read), current_user))
          @evaluation = Evaluation.find(@eval.id)
          Rails.logger.debug "EVALUATION created: #{@evaluation.id}"
          Rails.logger.debug "Create filename tag for : #{params[:file].original_filename}"
          @evaluation.tags.create(content: {'name': 'filename', 'value': "#{params[:file].original_filename}"})
          tags = []
          (Constants::TAG_NAMES - ['Filename']).map do |tag|
            if params.has_key?(tag.downcase) and params[tag.downcase].present?
              tags << {'name': "#{tag.downcase}", 'value': "#{params[tag.downcase]}"}
            end
          end
          tags.each do |tag|
            @evaluation.tags.create(content: tag)
          end
          Rails.logger.debug "EVALUATION TAGS: #{@evaluation.tags.inspect}"

          if circle.present?
            @circle = Circle.with_roles([:owner, :member], current_user).find_by(name: circle)
            @circle = Circle.create(name: circle, created_by: current_user) unless @circle
            @circle.evaluations << @evaluation
          end
          render body: 'SUCCESS: Evaluation uploaded'
        else
          render body: 'ERROR: Could not upload evaluation'
        end
      else
        render body: 'ERROR: User not authorized to upload'
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
        _, controls, _ = evaluation.status_counts
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

  def xccdf
    @xccdf = Xccdf.new
  end

  def create_xccdf
    @attribs = {}
    @attribs['benchmark.title'] = xccdf_params[:benchmark_title]
    @attribs['benchmark.id'] = xccdf_params[:benchmark_id]
    @attribs['benchmark.description'] = xccdf_params[:benchmark_description]
    @attribs['benchmark.version '] = xccdf_params[:benchmark_version]
    @attribs['benchmark.status'] = xccdf_params[:benchmark_status]
    @attribs['benchmark.status.date'] = xccdf_params[:benchmark_status_date]
    @attribs['benchmark.notice'] = xccdf_params[:benchmark_notice]
    @attribs['benchmark.notice.id'] = xccdf_params[:benchmark_notice_id]
    @attribs['benchmark.plaintext'] = xccdf_params[:benchmark_plaintext]
    @attribs['benchmark.plaintext.id'] = xccdf_params[:benchmark_plaintext_id]
    @attribs['reference.href'] = xccdf_params[:reference_href]
    @attribs['reference.dc.source'] = xccdf_params[:reference_dc_source]
    @attribs['reference.dc.publisher'] = xccdf_params[:reference_dc_publisher]
    @attribs['reference.dc.title'] = xccdf_params[:reference_dc_publisher]
    @attribs['reference.dc.subject'] = xccdf_params[:reference_dc_subject]
    @attribs['reference.dc.type'] = xccdf_params[:reference_dc_type]
    @attribs['reference.dc.identifier'] = xccdf_params[:reference_dc_identifier]
    @attribs['content_ref.href'] = xccdf_params[:content_ref_href]
    @attribs['content_ref.name'] = xccdf_params[:content_ref_name]
    Rails.logger.debug "Attributes: #{@attribs.inspect}"
    render xml: @evaluation.to_xccdf(@attribs), layout: false
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

  def sign_in_api_user(email, api_key)
    if (user = User.where(email: email, api_key: api_key).first)
      sign_in user
      if user.type == 'DbUser'
        session['user_id'] = session['warden.user.db_user.key'].first.try(:first)
      elsif user.type == 'LdapUser'
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

  def tag_params
    params.require(:tag).permit(:name, :value)
  end

  def xccdf_params
    params.require(:xccdf).permit(:benchmark_title, :benchmark_id, :benchmark_description, :benchmark_version, :benchmark_status, :benchmark_status_date, :benchmark_notice, :benchmark_notice_id, :benchmark_plaintext, :benchmark_plaintext_id, :reference_href, :reference_dc_source, :reference_dc_publisher, :reference_dc_title, :reference_dc_subject, :reference_dc_type, :reference_dc_identifier, :content_ref_href, :content_ref_name, :plaintext_notice, :plaintext_notice_id)
  end
end
