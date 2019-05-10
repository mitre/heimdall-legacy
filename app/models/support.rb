class Support < ApplicationRecord
  belongs_to :profile, inverse_of: :supports
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.set!(name, value)
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
