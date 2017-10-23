json.extract! profile, :id, :name, :title, :maintainer, :copyright, :copyright_email, :license, :summary, :version, :sha256, :depends, :supports, :controls, :groups, :profile_attributes, :created_at, :updated_at
json.url profile_url(profile, format: :json)
