require 'inspec2ckl'

class Evaluation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  resourcify
  field :version, type: String
  field :other_checks, type: Array, default: []
  field :platform_name, type: String
  field :platform_release, type: String
  field :statistics_duration, type: String
  has_many :results
  has_and_belongs_to_many :profiles

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :version, :other_checks
      json.profiles(profiles.collect { |profile| profile.to_jbuilder.attributes! })
      json.platform do
        json.name platform_name
        json.release platform_release
      end
      json.statistics do
        json.duration statistics_duration
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end

  def to_ckl
    inspec2ckl = Inspec2ckl.new(to_json, nil, nil, nil)
    inspec2ckl.to_ckl
  end

  def status_counts
    counts = { open: 0, not_a_finding: 0, not_reviewed: 0, not_tested: 0, not_applicable: 0 }
    controls = {}
    profiles.each do |profile|
      profile.controls.each do |control|
        controls[control.id] = { control: control, results: [] }
      end
    end
    results.each do |result|
      controls[result.control_id][:results] << result
    end
    controls.each do |_, ct|
      sym = status_symbol(ct[:control], ct[:results])
      ct[:status_symbol] = sym
      counts[sym] += 1
    end
    [counts, controls]
  end

  def status_symbol(control, ct_results)
    if control.impact.zero?
      :not_applicable
    elsif ct_results.nil?
      :not_tested
    else
      status_list = ct_results.map(&:status).uniq
      if status_list.include?('failed')
        :open
      elsif status_list.include?('passed')
        :not_a_finding
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
    when :not_a_finding then 0.6
    when :open then 0.8
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

  def tag_values(tag, control, params, nist)
    tag.good_values.each do |value|
      nist[value] = [] unless nist[value]
      sym = status_symbol(control, params[:ct_results])
      next unless params[:status_symbol].nil? || params[:status_symbol] == sym
      nist[value] << { "name": control.control_id.to_s, "status_value": status_symbol_value(sym), "children":
        [{ "name": control.control_id.to_s, "title": control.title, "nist": control.tag('nist'),
          "status_symbol": sym, "status_value": status_symbol_value(sym),
          "severity": params[:severity], "description": control.desc,
          "check": control.tag('check'), "fix": control.tag('fix'),
          "impact": control.impact, "value": 1 }] }
    end
  end

  def profile_values(cat, params)
    nist = {}
    profiles.each do |profile|
      profile.controls.each do |control|
        params[:ct_results] = params[:cts][control.id]
        severity = control.severity
        next unless severity && (cat.nil? || cat == severity)
        params[:severity] = severity
        control.tags.where(name: 'nist').each do |tag|
          tag_values tag, control, params, nist
        end
      end
    end
    nist
  end

  def nist_hash(cat, status_symbol)
    cts = {}
    results.each do |result|
      unless cts.key?(result.control_id)
        cts[result.control_id] = []
      end
      cts[result.control_id] << result
    end
    params = { status_symbol: status_symbol, cts: cts }
    profile_values cat, params
  end

  def self.transform(hash)
    hash.deep_transform_keys! { |key| key.to_s.tr('-', '_').gsub(/\battributes\b/, 'profile_attributes').gsub(/\bid\b/, 'control_id') }
    hash.delete('controls')
    platform = hash.delete('platform')
    platform.try(:each) do |key, value|
      hash["platform_#{key}"] = value
    end
    statistics = hash.delete('statistics')
    statistics.try(:each) do |key, value|
      hash["statistics_#{key}"] = value
    end
    all_profiles, results = Profile.parse hash.delete('profiles')
    hash['results'] = results
    hash['profiles'] = all_profiles
    logger.debug("hash: #{hash.inspect}")
    hash
  end

  def self.parse(json_content)
    contents = json_content
    begin
      hash = Evaluation.transform(contents)
      results = hash.delete('results')
      profiles = hash.delete('profiles')
      if profiles.empty?
        evaluation = nil
      else
        evaluation = Evaluation.create(hash)
        results.each do |result|
          evaluation.results << result
        end
        profiles.each do |profile|
          evaluation.profiles << profile
        end
      end
      evaluation
    rescue Mongoid::Errors::UnknownAttribute
      nil
    end
  end
end
