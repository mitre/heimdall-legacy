class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :controls, type: Array, default: []
  field :control_id, type: String
  embedded_in :profile, inverse_of: :groups
  validates_presence_of :title

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :title, :controls
      json.id control_id
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end

  def controls_list=(arg)
    self.controls = arg.split(',').map(&:strip)
  end

  def controls_list
    controls.join(', ')
  end
end
