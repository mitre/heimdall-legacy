class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :title, type: String
  field :maintainer, type: String
  field :copyright, type: String
  field :copyright_email, type: String
  field :license, type: String
  field :summary, type: String
  field :version, type: String
  field :sha256, type: String
  embeds_many :depends, cascade_callbacks: true
  embeds_many :supports, cascade_callbacks: true
  embeds_many :controls, cascade_callbacks: true
  embeds_many :groups, cascade_callbacks: true
  embeds_many :profile_attributes, cascade_callbacks: true
  accepts_nested_attributes_for :controls
  accepts_nested_attributes_for :supports
  accepts_nested_attributes_for :groups
  accepts_nested_attributes_for :profile_attributes
  #has_and_belongs_to_many :evaluations
end
