class Evaluation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :version, type: String
  field :other_checks, type: Array, default: []
  field :platform_name, type: String
  field :platform_release, type: String
  field :statistics_duration, type: String
  #has_and_belongs_to_many :profiles
  embeds_many :results, cascade_callbacks: true
  accepts_nested_attributes_for :results
end
