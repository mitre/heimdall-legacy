json.extract! aspect, :name
json.options do
  json.description aspect.options[:description]
  if aspect.options[:default].size == 1
    if aspect.options[:default].first.numeric?
      json.default Float(aspect.options[:default].first)
    else
      json.default aspect.options[:default].first
    end
  else
    json.default aspect.options[:default]
  end
end
