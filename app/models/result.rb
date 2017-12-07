class Result
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :code_desc, type: String
  field :skip_message, type: String
  field :resource, type: String
  field :run_time, type: Float
  field :start_time, type: Date
  field :message, type: String
  field :exception, type: String
  field :backtrace, type: Array, default: []
  field :control_id, type: String
  field :profile_name, type: String
  belongs_to :evaluation, :inverse_of => :results
  attr_accessor :control
  attr_accessor :profile

  def status_symbol
    if self.status.include?('failed')
      :open
    elsif self.status.include?('passed')
      :not_a_finding
    elsif self.status.include?('skipped')
      :not_reviewed
    else
      :not_tested
    end
  end

  def profile
    @attributes["profile"] ||= Profile.find_by(:name => self.profile_name)
  end

  def profile=(value)
    @attributes["profile"] = value
  end

  def control
    @attributes["control"] ||= self.profile.controls.find_by(:control_id => self.control_id)
  end

  def control=(value)
    @attributes["control"] = value
  end
end
