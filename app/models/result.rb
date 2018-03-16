class Result
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :status, type: String
  field :code_desc, type: String
  field :skip_message, type: String
  field :resource, type: String
  field :run_time, type: Float
  field :start_time, type: Date
  field :message, type: String
  field :exception, type: String
  field :backtrace, type: Array, default: []
  belongs_to :evaluation, inverse_of: :results
  belongs_to :control, inverse_of: :results

  def status_symbol
    if status.include?('failed')
      :open
    elsif status.include?('passed')
      :not_a_finding
    elsif status.include?('skipped')
      :not_reviewed
    else
      :not_tested
    end
  end
end
