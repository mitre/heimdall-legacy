json.extract! profile_attribute, :name
json.options do
  json.description profile_attribute.option_description
  if profile_attribute.option_default.size == 1
    if profile_attribute.option_default.first.numeric?
      json.default Float(profile_attribute.option_default.first)
    else
      json.default profile_attribute.option_default.first
    end
  else
    json.default profile_attribute.option_default
  end
end
