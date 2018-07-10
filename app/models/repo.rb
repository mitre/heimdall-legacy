require 'git'

class Repo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :name, type: String
  field :api_url, type: String
  field :repo_type, type: String
  embeds_many :repo_creds, cascade_callbacks: true
  validates_presence_of :name, :api_url, :repo_type

  def self.types
    %w{GitLab GitHub}
  end

  def projects(repo_cred)
    return [] unless repo_cred&.token?
    if repo_type == 'GitLab'
      begin
        api = Git::GitLabProxy.new(api_url, repo_cred.token)
        api.projects
      rescue Gitlab::Error::Unauthorized, UncaughtThrowError
        []
      end
    elsif repo_type == 'GitHub'
      begin
        api = Git::GitHubProxy.new(repo_cred.token)
        api.projects
      rescue Octokit::Unauthorized, UncaughtThrowError
        []
      end
    end
  end
end
