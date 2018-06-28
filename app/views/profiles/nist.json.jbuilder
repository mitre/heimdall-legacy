total_impact = 0
total_children = 0
json.name @name
json.children @families do |family|
  next if family['name'] == 'UM' && @control_hash['UM-1'].nil?
  cf_total_impact = 0.0
  cf_total_children = 0
  json.name family['name']
  json.desc family['desc']
  json.children family['children'] do |control|
    control_total_impact = 0.0
    control_total_children = 0
    json.name control['name']
    json.value 1
    if @control_hash[control['name']]
      json.children @control_hash[control['name']].each do |child|
        json.name child[:name]
        json.severity child[:severity]
        json.impact child[:impact]
        json.value 1
        if child[:impact]
          control_total_children += 1
          control_total_impact += child[:impact]
        end
      end
    end
    json.impact control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children
    cf_total_impact += control_total_impact
    cf_total_children += control_total_children
  end
  json.impact cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children
  total_impact += cf_total_impact
  total_children += cf_total_children
end
json.impact total_impact == 0.0 ? 0.0 : total_impact/total_children
