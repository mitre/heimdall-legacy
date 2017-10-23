class Support
  include Mongoid::Document
  field :os_family, type: String
  embedded_in :profile, :inverse_of => :supports
end
