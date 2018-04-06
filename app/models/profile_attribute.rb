class ProfileAttribute
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :option_description, type: String
  field :option_default, type: Array, default: []
  field :option_required, type: Boolean
  embedded_in :profile, inverse_of: :profile_attributes
  validates_presence_of :name

  def option_default_list=(arg)
    self.option_default = arg.split(',').map(&:strip)
  end

  def option_default_list
    option_default.join(', ')
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name
      json.options do
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
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end
end
