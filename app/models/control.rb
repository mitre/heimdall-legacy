class Control
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :desc, type: String
  field :impact, type: Float
  field :refs, type: Array, default: []
  field :code, type: String
  field :control_id, type: String
  field :tag_severity, type: String
  field :tag_gtitle, type: String
  field :tag_gid, type: String
  field :tag_rid, type: String
  field :tag_stig_id, type: String
  field :tag_cci, type: String
  field :tag_nist, type: Array, default: []
  field :tag_subsystems, type: Array, default: []
  field :tag_check, type: String
  field :tag_fix, type: String
  field :sl_ref, type: String
  field :sl_line, type: Integer
  embedded_in :profile, :inverse_of => :controls

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
