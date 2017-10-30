class Result
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  field :code_desc, type: String
  field :skip_message, type: String
  field :resource, type: String
  field :run_time, type: Float
  field :start_time, type: Date
  field :control_id, type: String
  embedded_in :evaluation, :inverse_of => :results
  #belongs_to :evaluation
  #belongs_to :control, :inverse_of => :results
end
