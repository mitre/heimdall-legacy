class RepoCred
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :username, type: String
  field :token, type: String
  embedded_in :repo, inverse_of: :repo_creds
  validates_presence_of :username
end
