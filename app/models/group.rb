class Group < ApplicationRecord
  serialize :controls
  belongs_to :profile, inverse_of: :groups
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

  def to_json(*_args)
    to_jbuilder.target!
  end
end
