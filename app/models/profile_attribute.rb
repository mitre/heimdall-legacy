class ProfileAttribute
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :option_description, type: String
  field :option_default, type: Array, default: []
  field :option_required, type: Boolean
  embedded_in :profile, inverse_of: :profile_attributes
  validates_presence_of :name

  def option_default_list=(arg)
    self.option_default = arg.split(',').map(&:strip)
  end

  def option_default_list
    option_default.join(', ')
  end
end
