class WaiverData < ApplicationRecord
  belongs_to :control

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :justification, :run, :skipped_due_to_waiver, :message
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
