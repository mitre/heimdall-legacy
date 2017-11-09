class Control
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :desc, type: String
  field :impact, type: Float
  field :refs, type: Array, default: []
  field :code, type: String
  field :control_id, type: String
  embeds_many :tags, cascade_callbacks: true
  field :sl_ref, type: String
  field :sl_line, type: Integer
  embedded_in :profile, :inverse_of => :controls
  #has_many :results
  #accepts_nested_attributes_for :results


  def refs_list=(arg)
    self.refs = arg.split(',').map { |v| v.strip }
  end

  def refs_list
    self.refs.join(', ')
  end

  def tag_nist_list=(arg)
    self.tag_nist = arg.split(',').map { |v| v.strip }
  end

  def tag_nist_list
    self.tag_nist.join(', ')
  end

  def tag_subsystems_list=(arg)
    self.tag_subsystems = arg.split(',').map { |v| v.strip }
  end

  def tag_subsystems_list
    self.tag_subsystems.join(', ')
  end
end
