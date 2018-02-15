json.extract! repo_cred, :id, :username, :token, :created_at, :updated_at
json.url repo_cred_url(repo_cred, format: :json)
