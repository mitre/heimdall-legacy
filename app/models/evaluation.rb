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

  def status_counts
    counts = {open: 0, not_a_finding: 0, not_reviewed: 0, not_tested: 0, not_applicable: 0}
    controls = {}
    profiles.each do |profile|
      profile.controls.each do |control|
        controls[control.id] = {control: control, results: []}
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

  def status_symbol control, ct_results
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

  def status_symbol_value symbol
    if symbol == :not_applicable
      0.2
    elsif symbol == :not_reviewed
      0.4
    elsif symbol == :not_a_finding
      0.6
    elsif symbol == :open
      0.8
    else
      0.0
    end
  end

  def nist_hash cat, status_symbol
    nist = {}
    cts = {}
    results.each do |result|
      unless cts.key?(result.control_id)
        cts[result.control_id] = []
      end
      cts[result.control_id] << result
    end
    profiles.each do |profile|
      profile.controls.each do |control|
        ct_results = cts[control.id]
        severity = control.tags.where(name: 'severity').first
        next unless severity && (cat.nil? || cat == severity.value)
        control.tags.where(name: 'nist').each do |tag|
          next unless tag.value.is_a? Array
          tag.value.each do |value|
            next if value.include?('Rev')
            value = value.split('(')[0].strip
            nist[value] = [] unless nist[value]
            sym = status_symbol(control, ct_results)
            next unless status_symbol.nil? || status_symbol == sym
            nist[value] << {"name": control.control_id.to_s, "status_value": status_symbol_value(sym), "children":
              [{"name": control.control_id.to_s, "title": control.title, "nist": control.tag('nist'),
                "status_symbol": sym, "status_value": status_symbol_value(sym),
                "severity": severity.value, "description": control.desc,
                "check": control.tag('check'), "fix": control.tag('fix'),
                "impact": control.impact, "value": 1}]}
          end
        end
      end
    end
    #logger.debug "nist: #{nist}"
    nist
  end

  def self.transform hash
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
      profile = Profile.where(sha256: profile_hash['sha256']).try(:first)
      unless profile
        new_profile_hash, controls = Profile.transform(profile_hash.deep_dup)
        profile = Profile.create(new_profile_hash)
        controls.each do |control|
          logger.debug "Add Control: #{control.keys}"
          profile.controls.create(control)
        end
      end
      profile_hash['controls'].try(:each) do |control_hash|
        logger.debug "For #{control_hash['control_id']}"
        if (control = profile.controls.where(control_id: control_hash['control_id']).try(:first))
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

  def self.parse json_content
    contents = json_content
    begin
      hash = Evaluation.transform(contents)
      results = hash.delete('results')
      profiles = hash.delete('profiles')
      evaluation = Evaluation.create(hash)
      results.each do |result|
        evaluation.results << result
      end
      profiles.each do |profile|
        evaluation.profiles << profile
      end
      evaluation
    rescue
      nil
    end
  end
end
