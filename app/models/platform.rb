class Platform < ApplicationRecord
  belongs_to :evaluation

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name, :release
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
