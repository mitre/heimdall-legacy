def calc_status_value(status_value, curr_value, curr_total)
  if status_value
    if status_value > 0.4
      if curr_value < 0.6
        curr_total = 1
        curr_value = status_value
      else
        curr_total += 1
        curr_value += status_value
      end
      if status_value > 0.6
        curr_total += 4
        curr_value += 4 * status_value
      end
    elsif curr_value < 0.6
      curr_value = 0.4
      curr_total = 1
    end
  end
  [curr_value, curr_total]
end

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
    if @control_hash[control['name']]
      json.children @control_hash[control['name']].each do |child|
        json.name child[:name]
        json.status_value child[:status_value]
        childf = child[:children].first
        control_total_impact, control_total_children = calc_status_value childf[:status_value], control_total_impact, control_total_children
        json.children child[:children].each do |child_desc|
          json.name child_desc[:name]
          json.title child_desc[:title]
          json.nist child_desc[:nist]
          json.status_symbol child_desc[:status_symbol]
          json.status_value child_desc[:status_value]
          json.severity child_desc[:severity]
          json.description child_desc[:description]
          json.check child_desc[:check]
          json.fix child_desc[:fix]
          json.impact child_desc[:impact]
          json.value 1
        end
      end
    else
      json.value 1
    end
    json.status_value control_total_impact == 0.0 ? 0.0 : control_total_impact/control_total_children
    cf_total_impact += control_total_impact
    cf_total_children += control_total_children
  end
  json.status_value cf_total_impact == 0.0 ? 0.0 : cf_total_impact/cf_total_children
  total_impact += cf_total_impact
  total_children += cf_total_children
end
json.status_value total_impact == 0.0 ? 0.0 : total_impact/total_children
