class Evaluation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :version, type: String
  field :other_checks, type: Array, default: []
  field :platform_name, type: String
  field :platform_release, type: String
  field :statistics_duration, type: String
  embeds_many :results, cascade_callbacks: true
  accepts_nested_attributes_for :results

  @counts = nil
  @control_hash = nil
  @profile_hash = nil
  @control_results_hash = nil

  def profiles profile_name=nil
    if @profile_hash.nil?
      @profile_hash = {}
      self.results.map(&:profile_name).uniq.each do |name|
        @profile_hash[name] = Profile.find_by(:name => name)
      end
    end
    if profile_name
      @profile_hash[profile_name]
    else
      @profile_hash
    end
  end

  def fill_hashes
    @control_hash = {}
    @control_results_hash = {}
    self.results.each do |result|
      if profile = self.profiles(result.profile_name)
        profile.controls.each do |control|
          @control_hash[control.control_id] = control
          unless @control_results_hash.key?(control.control_id)
            @control_results_hash[control.control_id] = []
          end
          if result.control_id == control.control_id
            @control_results_hash[control.control_id] << result
          end
        end
      end
    end
  end

  def control_results control_id=nil
    if @control_results_hash.nil?
      fill_hashes
    end
    if control_id
      @control_results_hash[control_id]
    else
      @control_results_hash
    end
  end

  def controls control_id=nil
    if @control_hash.nil?
      fill_hashes
    end
    if control_id
      @control_hash[control_id]
    else
      @control_hash
    end
  end

  def status_counts
    if @counts.nil?
      counts = {open: 0, not_a_finding: 0, not_reviewed: 0, not_tested: 0, not_applicable: 0}
      control_results.each do |control_id, results|
        if control = self.controls(control_id)
          counts[status_symbol(control)] += 1
        end
      end
    end
    counts
  end

  @@categories = {"cat i": {low: 0.7, high: 0.9}, "cat ii": {low: 0.4, high: 0.6}, "cat iii": {low: 0.1, high: 0.3},}

  def category cat
    if cat
      @@categories[cat.downcase.to_sym]
    else
      nil
    end
  end

  def status_symbol control
    if control.impact.zero?
      :not_applicable
    else
      status_list = control_results[control.control_id].map{ |result| result.status}.uniq
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
    range = self.category cat
    #logger.debug "CAT: #{cat}, range: #{range.inspect}, status_symbol: #{status_symbol}"
    control_results.each do |control_id, results|
      if control = self.controls(control_id)
        #logger.debug "#{control.control_id}: #{control.impact}"
        if range.nil? || (control.impact <= range[:high] && control.impact >= range[:low])
          if severity = control.tags.where(:name => 'severity').first
            control.tags.where(:name => 'nist').each do |tag|
              if tag.value.is_a? Array
                tag.value.each do |value|
                  unless value.include?("Rev")
                    value = value.split(' ')[0]
                    nist[value] = [] unless nist[value]
                    sym = status_symbol(control)
                    #logger.debug "#{control.control_id}: sym = #{sym}, equals #{status_symbol}: #{status_symbol == sym}"
                    if status_symbol.nil? || status_symbol == sym
                      nist[value] << {"name": "#{control.control_id}", "status_symbol": sym, "status_value": status_symbol_value(sym), "severity": "#{severity.value}", "impact": control.impact, "value": 1}
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    nist
  end
end
