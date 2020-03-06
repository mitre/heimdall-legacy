json.extract! evaluation, :version
json.profiles evaluation.profiles do |profile|
  json.partial! 'profiles/profile', profile: profile
end
json.platform do
  json.name evaluation.platform&.name
  json.release evaluation.platform&.release
end
json.statistics do
  json.duration evaluation.statistic&.duration.to_f
end
