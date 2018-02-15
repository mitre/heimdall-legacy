class Repo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :name, type: String
  field :api_url, type: String
  field :repo_type, type: String
  embeds_many :repo_creds, cascade_callbacks: true
  validates_presence_of :name, :api_url, :repo_type
  
  def self.types
    ["GitLab", "GitHub"]
  end
end
