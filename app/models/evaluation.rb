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
        controls[control.id] = {:control => control, :results => []}
      end
    end
    results.each do |result|
      controls[result.control_id][:results] << result
    end
    controls.each do |control_id, ct|
      sym = status_symbol(ct[:control], ct[:results])
      ct[:status_symbol] = sym
      counts[sym] += 1
    end
    return counts, controls
  end

  def status_symbol control, ct_results
    if control.impact.zero?
      :not_applicable
    else
      if ct_results.nil?
        :not_tested
      else
        status_list = ct_results.map{ |result| result.status}.uniq
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
  end

  def status_symbol_value symbol
    if symbol == :not_applicable
      return 0.2
    elsif symbol == :not_reviewed
      return 0.4
    elsif symbol == :not_a_finding
      return 0.6
    elsif symbol == :open
      return 0.8
    else
      return 0.0
    end
  end

  def nist_hash cat, status_symbol
    nist = {}
    logger.debug "CAT: #{cat}, status_symbol: #{status_symbol}"
    cts = {}
    results.each do |result|
      unless cts.key?(result.control_id)
        cts[result.control_id] = []
      end
      cts[result.control_id] << result
    end
    profiles.each do |profile|
      #logger.debug "Profile: #{profile.name}"
      profile.controls.each do |control|
        logger.debug "#{control.control_id}: #{control.impact}, severity #{control.tags.where(:name => 'severity').first.try(:value)}"
        ct_results = cts[control.id]
        if severity = control.tags.where(:name => 'severity').first
          if cat.nil? || cat == severity.value
            #logger.debug "severity: #{severity.value}"
            control.tags.where(:name => 'nist').each do |tag|
              if tag.value.is_a? Array
                tag.value.each do |value|
                  unless value.include?("Rev")
                    value = value.split('(')[0].strip
                    nist[value] = [] unless nist[value]
                    sym = status_symbol(control, ct_results)
                    logger.debug "#{control.control_id}: nist: #{value}, sym = #{sym}, equals #{status_symbol}: #{status_symbol == sym}"
                    if status_symbol.nil? || status_symbol == sym
                      logger.debug "#{control.control_id}: nist: #{value}, status_value: #{status_symbol_value(sym)}"
                      nist[value] << {"name": "#{control.control_id}", "status_value": status_symbol_value(sym), "children":
                        [{"name": "#{control.control_id}", "title": control.title, "nist": control.tag('nist'),
                          "status_symbol": sym, "status_value": status_symbol_value(sym),
                          "severity": "#{severity.value}", "description": control.desc,
                          "check": control.tag('check'), "fix": control.tag('fix'),
                          "impact": control.impact, "value": 1}]}
                    end
                  end
                end
              end
            end
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
      profile = Profile.where(:sha256 => profile_hash['sha256']).try(:first)
      unless profile
        new_profile_hash, controls = Profile.transform(profile_hash.deep_dup)
        profile = Profile.create(new_profile_hash)
        controls.each do |control|
          logger.debug "Add Control: #{control.keys}"
          profile.controls.create(control)
        end
      end
      logger.debug "Add RESULTS"
      profile_hash['controls'].try(:each) do |control_hash|
        logger.debug "For #{control_hash['control_id']}"
        if control = profile.controls.where(:control_id => control_hash['control_id']).try(:first)
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
    Rails.logger.debug "json_content: #{json_content.class}"
    contents = json_content
    #contents = JSON.parse(json_content)
    Rails.logger.debug "contents keys: #{contents.keys()}"
    if contents.key?("profiles") || contents.key?(:profiles)
      Rails.logger.debug "transform hash"
      hash = Evaluation.transform(contents)
      results = hash.delete('results')
      profiles = hash.delete('profiles')
      evaluation = Evaluation.create(hash)
      logger.debug("New Evaluation: #{evaluation.inspect}")
      results.each do |result|
        logger.debug("Add result to evaluation")
        evaluation.results << result
      end
      logger.debug("Results: #{evaluation.results.size}")
      profiles.each do |profile|
        logger.debug("Add profile to evaluation")
        evaluation.profiles << profile
      end
      logger.debug("Profiles: #{evaluation.profiles.size}")
      return evaluation
    else
      Rails.logger.debug "return nil"
      return nil
    end
  end
end
