class Aspect < ApplicationRecord
  belongs_to :profile
  store :options, accessors: [ :description, :value, :type ], coder: JSON
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name
      json.options do
        json.type option_type
        json.description option_description
        if option_default.size == 1
          if option_default.first.numeric?
            json.default Float(option_default.first)
          else
            json.default option_default.first
          end
        else
          json.default option_default
        end
        if option_value.size == 1
          if option_value.first.numeric?
            json.default Float(option_value.first)
          else
            json.default option_value.first
          end
        else
          json.default option_value
        end
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end
end
