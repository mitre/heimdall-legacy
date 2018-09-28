class Support
  include Mongoid::Document
  field :os_family, type: String
  field :name, type: String
  field :value, type: String
  embedded_in :profile, inverse_of: :supports
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.set!(name, value)
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end
end
