json.extract! control, :title, :desc, :impact, :refs
json.tags do
  control.tags.each do |tag|
    json.set!(tag.name, tag.value)
  end
end
json.extract! control, :code
json.source_location do
  json.ref control.sl_ref
  json.line control.sl_line
end
json.id control.control_id
if control.results.present?
  json.results control.results do |result|
    json.partial! 'results/result', result: result
  end
end
