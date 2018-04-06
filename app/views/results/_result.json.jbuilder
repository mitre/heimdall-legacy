json.ignore_nil! true
json.extract! result, :status, :code_desc, :skip_message, :resource, :run_time, :start_time, :message, :exception
unless result.backtrace.empty?
  json.extract! result, :backtrace
end
