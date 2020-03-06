class Result < ApplicationRecord
  serialize :backtrace_array
  belongs_to :control, inverse_of: :results
  belongs_to :evaluation

  def to_jbuilder
    Jbuilder.new do |json|
      json.ignore_nil! true
      json.extract! self, :status, :code_desc, :skip_message, :resource, :run_time, :start_time, :message, :exception
      unless backtrace.nil?
        json.extract! self, :backtrace
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json(*_args)
    to_jbuilder.target!
  end

  def status_symbol
    if backtrace.present?
      :profile_error
    elsif status.include?('failed')
      :failed
    elsif status.include?('passed')
      :passed
    elsif status.include?('skipped')
      :not_reviewed
    else
      :profile_error
    end
  end
end
