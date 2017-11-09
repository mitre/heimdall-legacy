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

  def controls control_id=nil
    if @control_hash.nil?
      @control_hash = {}
      self.results.each do |result|
        if profile = self.profiles(result.profile_name)
          profile.controls.each do |control|
            @control_hash[control.control_id] = control
          end
        end
      end
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
      results.each do |result|
        if result.status.include?('failed')
          counts[:open] += 1
        elsif result.status.include?('passed')
          counts[:not_a_finding] += 1
        elsif result.status.include?('skipped')
          counts[:not_reviewed] += 1
        else
          counts[:not_tested] += 1
        end
        if control = self.controls(result.control_id)
          if control.impact.zero?
            counts[:not_applicable] += 1
          end
        end
      end
    end
    counts
  end
end
