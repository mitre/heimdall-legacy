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
  belongs_to :profile, :inverse_of => :controls
  #has_many :results
  #accepts_nested_attributes_for :results
["title", "desc", "impact", "refs", "code", "control_id", "results", "tags", "sl_ref", "sl_line"]

  def refs_list=(arg)
    self.refs = arg.split(',').map { |v| v.strip }
  end

  def refs_list
    self.refs.join(', ')
  end

  def tag name
    val = self.tags.where(:name => name).first.try(:value)
    if val.kind_of?(Array)
      val.join(", ")
    else
      val
    end
  end

end
