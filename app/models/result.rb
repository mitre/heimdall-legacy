class Result
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :code_desc, type: String
  field :skip_message, type: String
  field :resource, type: String
  field :run_time, type: Float
  field :start_time, type: Date
  field :control_id, type: String
  field :profile_name, type: String
  embedded_in :evaluation, :inverse_of => :results
  attr_accessor :control
  attr_accessor :profile

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
