class Aspect < ApplicationRecord
  belongs_to :profile
  store :options, accessors: [:default, :description, :value, :type, :required], coder: JSON
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name, :options
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
