json.extract! repo, :id, :name, :api_url, :created_at, :updated_at
json.url repo_url(repo, format: :json)
