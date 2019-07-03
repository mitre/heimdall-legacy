require 'inspec_tools'

class Evaluation < ApplicationRecord
  store :platform, accessors: [:name, :release], coder: JSON
  serialize :other_checks
  store :statistics, accessors: [:duration], coder: JSON
  store :findings, accessors: [:failed, :passed, :not_reviewed, :not_tested, :not_applicable], coder: JSON
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
    base_profile.dependants
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
    counts = { failed: 0, passed: 0, not_reviewed: 0, not_tested: 0, not_applicable: 0 }
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
    #Rails.logger.debug "control: #{control.inspect}, ct_results: #{ct_results.inspect}"
    if control.impact == 'none'
      :not_applicable
    elsif ct_results.nil?
      :not_tested
    else
      status_list = ct_results.map(&:status).uniq
      if status_list.include?('failed')
        :failed
      elsif status_list.include?('passed')
        :passed
      elsif status_list.include?('skipped')
        :not_reviewed
      else
        :not_tested
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

  def nist_hash(cat, status_symbol, ex_ids, filters = nil)
    nist = {}
    params = { status_symbol: status_symbol }
    profiles.includes(controls: :results).each do |profile|
      next if ex_ids.include?(profile.id)
      if profiles.size == 1 or profile.dependants.empty?
        profile.controls.each do |control|
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
      end
    end
    nist
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
      all_profiles, parent = Profile.parse(profiles, evaluation.id)
      all_profiles.each do |profile|
        if profile.is_a?(Profile)
          evaluation.profiles << profile
        else
          profile['created_by_id'] = user.id
          evaluation.profiles.create(profile)
        end
      end
    end
    if parent.present? and profiles.size > 1
      parent_profile = evaluation.profiles.where(name: parent).first
      if parent_profile.present?
        evaluation.profiles.where.not(name: parent).each do |dependant|
          existing = DependantsParent.where(parent_id: parent_profile.id, dependant_id: dependant.id).first
          unless existing.present?
            DependantsParent.create(parent_id: parent_profile.id, dependant_id: dependant.id)
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
