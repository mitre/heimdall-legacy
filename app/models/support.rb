class Support
  include Mongoid::Document
  field :os_family, type: String
  embedded_in :profile, inverse_of: :supports
  validates_presence_of :os_family

  def to_jbuilder
    Jbuilder.new do |json|
      json.set!('os-family', os_family)
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end
end
