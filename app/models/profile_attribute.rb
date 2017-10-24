class ProfileAttribute
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :option_description, type: String
  field :option_default, type: Array, default: []
  embedded_in :profile, :inverse_of => :profile_attributes

  def option_default_list=(arg)
    self.option_default = arg.split(',').map { |v| v.strip }
  end

  def option_default_list
    self.option_default.join(', ')
  end
end
