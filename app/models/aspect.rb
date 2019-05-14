class Aspect < ApplicationRecord
  belongs_to :profile
  store :options, accessors: [ :default, :description, :value, :type, :required ], coder: JSON
  validates_presence_of :name

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :name
      json.options do
        json.type options[:type]
        json.description options[:description]
        if options[:default]&.size == 1
          if options[:default].first.numeric?
            json.default Float(options[:default].first)
          else
            json.default options[:default].first
          end
        else
          json.default options[:default]
        end
        if options[:value]&.size == 1
          if options[:value].first.numeric?
            json.default Float(options[:value].first)
          else
            json.default options[:value].first
          end
        else
          json.default options[:value]
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
