json.extract! evaluation, :version, :other_checks
json.profiles evaluation.profiles do |profile|
  json.partial! 'profiles/profile', profile: profile
end
json.platform do
  json.name evaluation.platform_name
  json.release evaluation.platform_release
end
json.statistics do
  json.duration evaluation.statistics_duration
end
