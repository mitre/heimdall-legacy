class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :controls, type: Array, default: []
  field :control_id, type: String
  embedded_in :profile, :inverse_of => :groups

  def controls_list=(arg)
    self.controls = arg.split(',').map { |v| v.strip }
  end

  def controls_list
    self.controls.join(', ')
  end
end
