module Git
  class GitLabProxy
    attr_accessor :api_url
    attr_accessor :token

    def initialize(api_url, token)
      self.api_url = api_url
      self.token = token
    end

    def projects
      Gitlab.endpoint = api_url
      Gitlab.private_token = token
      projects = []
      hsh = Gitlab.projects
      if hsh.present?
        hsh.each do |gitlab_proj|
          repo = gitlab_proj.to_hash
          next unless repo['default_branch']
          next unless (tree = Gitlab.tree(repo['id']))
          tree.each do |file_hsh|
            next unless file_hsh.to_hash['name'] == 'inspec.yml'
            repo_proj = {}
            repo_proj[:name] = repo['name_with_namespace']
            repo_proj[:description] = repo['description']
            repo_proj[:html_url] = repo['http_url_to_repo']
            projects << repo_proj
            break
          end
        end
      end
      projects
    end
  end

  class GitHubProxy
    attr_accessor :token

    def initialize(token)
      self.token = token
    end

    def projects
      projects = []
      begin
        client = Octokit::Client.new(access_token: token)
        repos = client.repos.select { |repo| repo.name.include?('-baseline') }
      rescue NoMethodError
        repos = []
      end
      repos.each do |repo|
        begin
          client.contents(repo['full_name'], path: 'inspec.yml')
          repo_proj = {}
          repo_proj[:name] = repo['full_name']
          repo_proj[:description] = repo['description']
          repo_proj[:html_url] = repo['html_url']
          projects << repo_proj
        rescue Octokit::NotFound
          Rails.logger.debug 'no Inspec.yml'
        end
      end
      projects
    end
  end
end
