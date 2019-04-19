class Depend
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :path, type: String
  field :url, type: String
  field :status, type: String
  field :git, type: String
  field :branch, type: String
  embedded_in :profile, inverse_of: :depends
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name, :path, :status, :git, :branch
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
