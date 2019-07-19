require 'inspec_tools'
require 'fuzzystringmatch'

class Evaluation < ApplicationRecord
  store :platform, accessors: [:name, :release], coder: JSON
  serialize :other_checks
  store :statistics, accessors: [:duration], coder: JSON
  store :findings, accessors: [:failed, :passed, :not_reviewed, :profile_error, :not_applicable], coder: JSON
  has_many :tags, as: :tagger
  has_and_belongs_to_many :profiles
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  has_many :results, dependent: :destroy
  resourcify

  scope :recent, ->(num) { order(created_at: :desc).limit(num) }

  def findings
    Rails.logger.debug 'get findings'
    if read_attribute(:findings).empty?
      counts, _, start_tm = status_counts
      Rails.logger.debug "set start_time #{start_tm}"
      write_attribute(:findings, counts)
      write_attribute(:start_time, start_tm)
      save
    else
      Rails.logger.debug "read findings: #{read_attribute(:findings)}"
    end
    read_attribute(:findings)
  end

  def base_profile
    base = profiles.first
    if profiles.size > 1
      profiles.each do |profile|
        if profile.dependants.present?
          base = profile
          break
        end
      end
    end
    base
  end

  def included_profiles
    profiles.where.not(id: base_profile.id)
  end

  def fuzzy_match_profile(fuzzy_name, exclude)
    best = nil
    match = 0.4
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    profiles.where.not(id: exclude.id).each do |profile|
      val = jarow.getDistance(fuzzy_name, profile.name)
      if val > match
        match = val
        best = profile
      end
    end
    best
  end

  def profile_code(profile, control_id)
    code = "Profile Name: #{profile.name}\n"
    code += "=============================================================\n"
    control = profile.controls.where(control_id: control_id).first
    code += control&.code + "\n"
    profile.dependants&.each do |dependant|
      code += profile_code(dependant, control_id) + "\n"
    end
    code
  end

  def control_code(control)
    if base_profile.dependants.present?
      profile_code(base_profile, control.control_id)
    else
      control.code
    end
  end

  def filename
    tag = tags.select { |tg| tg.content[:name] == 'filename' }.first
    tag.nil? ? nil : tag.content[:value]
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :version, :other_checks
      json.profiles(profiles.collect { |profile| profile.to_jbuilder.attributes! })
      json.platform do
        json.name platform[:name]
        json.release platform[:release]
      end
      json.statistics do
        json.duration statistics[:duration]
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end

  def to_ckl
    tool = InspecTools::Inspec.new(to_json)
    tool.to_ckl
  end

  def to_csv
    tool = InspecTools::Inspec.new(to_json)
    tool.to_csv
  end

  def to_xccdf(attribs)
    tool = InspecTools::Inspec.new(to_json)
    tool.to_xccdf(attribs)
  end

  def force_created_by(user)
    self.created_by_type = User
    self.created_by_id = user.id
    self.created_at = Time.now
    save
  end

  def status_counts(filters = nil)
    counts = { failed: 0, passed: 0, not_reviewed: 0, profile_error: 0, not_applicable: 0 }
    controls = {}
    start_times = []
    if profiles.size > 1
      profiles.each do |profile|
        next unless profile.dependants.empty?
        p_controls = filters.nil? ? profile.controls : profile.filtered_controls(filters)
        p_controls.each do |control|
          unless control.results.empty?
            unless controls.key?(control.control_id)
              controls[control.control_id] = { control: control, results: [] }
            end
            control.results.where(evaluation_id: id).each do |result|
              controls[control.control_id][:results] << result
              start_times << result.start_time
            end
          end
        end
      end
    else
      profile = profiles.first
      p_controls = filters.nil? ? profile.controls : profile.filtered_controls(filters)
      p_controls.each do |control|
        controls[control.control_id] = { control: control, results: [] }
        control.results.where(evaluation_id: id).each do |result|
          controls[control.control_id][:results] << result
          start_times << result.start_time
        end
      end
    end
    start_tm = start_times.compact.sort.try(:first)
    controls.each do |_, ct|
      sym = status_symbol(ct[:control], ct[:results])
      ct[:status_symbol] = sym
      counts[sym] += 1
    end
    [counts, controls, start_tm]
  end

  def status_symbol(control, ct_results)
    if control.impact == 'none'
      :not_applicable
    elsif ct_results.nil?
      :profile_error
    else
      status_list = ct_results.map(&:status_symbol).uniq
      if status_list.include?(:profile_error)
        :profile_error
      elsif status_list.include?(:failed)
        :failed
      elsif status_list.include?(:passed)
        :passed
      elsif status_list.include?(:not_reviewed)
        :not_reviewed
      else
        :profile_error
      end
    end
  end

  def status_symbol_value(symbol)
    case symbol
    when :not_applicable then 0.2
    when :not_reviewed then 0.4
    when :passed then 0.6
    when :failed then 0.8
    else
      0.0
    end
  end

  def symbols
    _, controls = status_counts
    symbols = {}
    controls.each do |_, hsh|
      control = hsh[:control]
      symbols[control.control_id] = hsh[:status_symbol]
    end
    symbols
  end

  def result_message(symbol)
    if symbol == :not_applicable
      'Justification'
    elsif symbol == :failed
      'One or more of the automated tests failed or was inconclusive for the control'
    elsif symbol == :passed
      'All Automated tests passed for the control'
    elsif symbol == :not_reviewed
      'Automated test skipped due to known accepted condition in the control'
    else
      'No test available for this control'
    end
  end

  def tag_values(tag, control, params, nist)
    tag.each do |value|
      nist[value] = [] unless nist[value]
      ct_results = params[:results]
      sym = status_symbol(control, ct_results)
      next unless params[:status_symbol].nil? || params[:status_symbol] == sym

      code_descs = ct_results ? ct_results.map{ |result| "#{result.status.upcase} -- #{result.code_desc}" }.join("\n") : ''
      nist[value] << { "name": control.control_id.to_s, "status_value": status_symbol_value(sym), "children":
        [{ "name": control.control_id.to_s, "title": control.title, "nist": control.tag('nist'),
          "family": value, "status_symbol": sym, "status_value": status_symbol_value(sym),
          "severity": params[:severity], "description": control.desc,
          "check": control.tag('check'), "fix": control.tag('fix'), "start_time": control.start_time,
          "code": control.code, "run_time": control.run_time, "profile_id": control.profile_id,
          "profile_name": control.profile.name, "impact": control.impact, "value": 1, "id": control.id,
          "result_message": "#{result_message(sym)}\n\n#{code_descs}" }] }
    end
  end

  def profile_values(cat, params, ex_ids, filters = nil)
    nist = {}
    profiles.each do |profile|
      next if ex_ids.include?(profile.id)

      p_controls = filters.nil? ? profile.controls.includes(:results, :tags) : profile.filtered_controls(filters)
      p_controls.each do |control|
        params[:ct_results] = params[:cts][control.id]
        severity = control.severity
        next unless severity && (cat.nil? || cat == severity)

        params[:severity] = severity
        nist_tag = control.tag('nist', true)
        if nist_tag.empty?
          tag_values ['UM-1'], control, params, nist
        else
          tag_values nist_tag, control, params, nist
        end
      end
    end
    nist
  end

  def filtered_controls(ex_ids, filters = nil)
    controls = {}
    p_controls = filters.nil? ? base_profile.controls.includes(:results, :tags) : base_profile.filtered_controls(filters)
    p_controls.each do |control|
      controls[control.control_id] = control
    end
    included_profiles.each do |profile|
      if ex_ids.include?(profile.id)
        profile.controls.each do |control|
          controls.delete(control.control_id)
        end
      else
        d_controls = filters.nil? ? profile.controls.includes(:results, :tags) : profile.filtered_controls(filters)
        d_controls.each do |control|
          unless controls[control.control_id].present?
            controls[control.control_id] = control
          end
          unless controls[control.control_id].results.present?
            controls[control.control_id] = control
          end
        end
      end
    end
    controls.values
  end

  def nist_hash(cat, status_symbol_param, ex_ids, filters = nil)
    nist = {}
    params = { status_symbol: status_symbol_param }
    controls = filtered_controls(ex_ids, filters = nil)
    controls.each do |control|
      severity = control.severity
      next unless severity && (cat.nil? || cat == severity)
      params[:severity] = severity
      params[:results] = control.results.where(evaluation_id: id)
      nist_tag = control.tag('nist', true)
      if nist_tag.empty?
        tag_values ['UM-1'], control, params, nist
      else
        tag_values nist_tag, control, params, nist
      end
    end
    [nist, controls]
  end

  def self.parse(hash, user)
    hash.deep_transform_keys! { |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'aspects').gsub(/\bid\b/, 'control_id') }
    hash.delete('controls')

    profiles = hash.delete('profiles')
    if profiles.nil? or profiles.empty?
      evaluation = nil
    else
      hash['created_by_id'] = user.id
      evaluation = Evaluation.create(hash)
      evaluation.save
      all_profiles = Profile.parse(profiles, evaluation.id)
      all_profiles.each do |profile|
        if profile.is_a?(Profile)
          evaluation.profiles << profile
        else
          profile['created_by_id'] = user.id
          evaluation.profiles.create(profile)
        end
      end
    end

    if evaluation.profiles.size > 1
      evaluation.profiles.each do |profile|
        profile.depends&.each do |depend|
          child = evaluation.profiles.where(name: depend.name).first
          unless child.present?
            child = evaluation.fuzzy_match_profile(depend.name, profile)
          end
          if child.present?
            existing = DependantsParent.where(parent_id: profile.id, dependant_id: child.id).first
            unless existing.present?
              DependantsParent.create(parent_id: profile.id, dependant_id: child.id)
            end
          end
        end
      end
    end
    evaluation
  rescue Exception => e
    Rails.logger.debug "Import error: #{e.inspect}"
    nil
  end
end
