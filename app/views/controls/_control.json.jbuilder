json.extract! control, :title, :desc, :impact, :refs
if control.waiver_data.present?
  json.partial! 'waiver_datas/waiver_data', waiver_data: control.waiver_data
else
  json.waiver_data []
end
json.tags do
  control.tags.each do |tag|
    json.set!(tag.content['name'], tag.content['value'])
  end
end
json.extract! control, :code
json.source_location do
  json.ref control.source_location.ref
  json.line control.source_location.line
end
json.id control.control_id
if control.results.present?
  json.results control.results do |result|
    json.partial! 'results/result', result: result
  end
end
