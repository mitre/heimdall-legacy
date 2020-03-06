json.extract! profile, :name, :title, :maintainer, :copyright, :copyright_email, :license, :summary, :version
json.depends profile.depends do |depend|
  json.partial! 'depends/depend', depend: depend
end
json.supports profile.supports do |support|
  json.partial! 'supports/support', support: support
end
json.controls profile.controls do |control|
  json.partial! 'controls/control', control: control
end
json.groups profile.groups.where(:title => [nil, '']) do |group|
  json.partial! 'groups/group', group: group
end
json.attributes profile.inputs do |input|
  json.partial! 'inputs/input', input: input
end
json.extract! profile, :sha256
