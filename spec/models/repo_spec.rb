require 'rails_helper'

RSpec.describe Repo, type: :model do
  it { is_expected.to be_mongoid_document }

  context 'Stubbed as Unauthorized' do
    let(:user) { FactoryBot.create(:editor) }
    it 'GitLab returns an empty array on auth failure' do
      repo_cred = create :gitlab_cred, created_by: user
      @repo = repo_cred.repo
      Git::GitLabProxy.stubs(:new).throws(Gitlab::Error::Unauthorized)
      projects = @repo.projects repo_cred
      expect(projects).to eq []
    end

    it 'GitHub returns an empty array on auth failure' do
      repo_cred = create :github_cred, created_by: user
      @repo = repo_cred.repo
      Git::GitHubProxy.stubs(:new).throws(Octokit::Unauthorized)
      projects = @repo.projects repo_cred
      expect(projects).to eq []
    end
  end

  context 'GitLab Stubbed' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      @gitlab_response = [
        { hash:
          { 'id'=>12187, 'description'=>'experimental cli client for group', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true,
            'archived'=>false, 'visibility_level'=>20, 'ssh_url_to_repo'=>'git@gitlab.company.com:group/group-cli.git',
            'http_url_to_repo'=>'https://gitlab.company.com/group/group-cli.git', 'web_url'=>'https://gitlab.company.com/group/group-cli',
            'name'=>'group-cli', 'name_with_namespace'=>'group / group-cli', 'path'=>'group-cli', 'path_with_namespace'=>'group/group-cli',
            'resolve_outdated_diff_discussions'=>false, 'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true,
            'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true, 'created_at'=>'2017-12-07T00:50:11.441-05:00',
            'last_activity_at'=>'2017-12-07T00:50:11.441-05:00', 'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
        { hash:
          { 'id'=>11892, 'description'=>'', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true, 'archived'=>false, 'visibility_level'=>20,
            'ssh_url_to_repo'=>'git@gitlab.company.com:group/group3-server.git', 'http_url_to_repo'=>'https://gitlab.company.com/group/group3-server.git',
            'web_url'=>'https://gitlab.company.com/group/group3-server', 'name'=>'group3-server', 'name_with_namespace'=>'group / group3-server',
            'path'=>'group3-server', 'path_with_namespace'=>'group/group3-server', 'resolve_outdated_diff_discussions'=>nil,
            'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true,
            'snippets_enabled'=>true, 'created_at'=>'2017-11-07T14:00:29.084-05:00', 'last_activity_at'=>'2018-03-22T18:36:30.507-04:00',
            'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>'https://gitlab.company.com/uploads/-/system/project/avatar/11892/group-1853341_960_720.jpg', 'star_count'=>2, 'forks_count'=>0,
            'open_issues_count'=>87, 'public_builds'=>true, 'shared_with_groups'=>[], 'only_allow_merge_if_build_succeeds'=>false,
            'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
        { hash:
          { 'id'=>11870, 'description'=>'Pull Project data from ES and add to (dockerized) Splunk.', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>false,
            'archived'=>false, 'visibility_level'=>0, 'ssh_url_to_repo'=>'git@gitlab.company.com:group/Project-to-Splunk.git',
            'http_url_to_repo'=>'https://gitlab.company.com/group/Project-to-Splunk.git', 'web_url'=>'https://gitlab.company.com/group/Project-to-Splunk',
            'name'=>'Project-to-Splunk', 'name_with_namespace'=>'group / Project-to-Splunk', 'path'=>'Project-to-Splunk',
            'path_with_namespace'=>'group/Project-to-Splunk', 'resolve_outdated_diff_discussions'=>nil, 'container_registry_enabled'=>false,
            'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true,
            'created_at'=>'2017-11-06T12:28:09.720-05:00', 'last_activity_at'=>'2018-02-09T14:21:46.859-05:00', 'shared_runners_enabled'=>false,
            'lfs_enabled'=>true, 'creator_id'=>831,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
      ]

      @gitlab_response2 = [
        { 'id'=>12187, 'description'=>'experimental cli client for group', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true,
            'archived'=>false, 'visibility_level'=>20, 'ssh_url_to_repo'=>'git@gitlab.company.com:group/group-cli.git',
            'http_url_to_repo'=>'https://gitlab.company.com/group/group-cli.git', 'web_url'=>'https://gitlab.company.com/group/group-cli',
            'name'=>'group-cli', 'name_with_namespace'=>'group / group-cli', 'path'=>'group-cli', 'path_with_namespace'=>'group/group-cli',
            'resolve_outdated_diff_discussions'=>false, 'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true,
            'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true, 'created_at'=>'2017-12-07T00:50:11.441-05:00',
            'last_activity_at'=>'2017-12-07T00:50:11.441-05:00', 'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } },
        { 'id'=>11892, 'description'=>'', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true, 'archived'=>false, 'visibility_level'=>20,
            'ssh_url_to_repo'=>'git@gitlab.company.com:group/group3-server.git', 'http_url_to_repo'=>'https://gitlab.company.com/group/group3-server.git',
            'web_url'=>'https://gitlab.company.com/group/group3-server', 'name'=>'group3-server', 'name_with_namespace'=>'group / group3-server',
            'path'=>'group3-server', 'path_with_namespace'=>'group/group3-server', 'resolve_outdated_diff_discussions'=>nil,
            'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true,
            'snippets_enabled'=>true, 'created_at'=>'2017-11-07T14:00:29.084-05:00', 'last_activity_at'=>'2018-03-22T18:36:30.507-04:00',
            'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>'https://gitlab.company.com/uploads/-/system/project/avatar/11892/group-1853341_960_720.jpg', 'star_count'=>2, 'forks_count'=>0,
            'open_issues_count'=>87, 'public_builds'=>true, 'shared_with_groups'=>[], 'only_allow_merge_if_build_succeeds'=>false,
            'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } },
        { 'id'=>11870, 'description'=>'Pull Project data from ES and add to (dockerized) Splunk.', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>false,
            'archived'=>false, 'visibility_level'=>0, 'ssh_url_to_repo'=>'git@gitlab.company.com:group/Project-to-Splunk.git',
            'http_url_to_repo'=>'https://gitlab.company.com/group/Project-to-Splunk.git', 'web_url'=>'https://gitlab.company.com/group/Project-to-Splunk',
            'name'=>'Project-to-Splunk', 'name_with_namespace'=>'group / Project-to-Splunk', 'path'=>'Project-to-Splunk',
            'path_with_namespace'=>'group/Project-to-Splunk', 'resolve_outdated_diff_discussions'=>nil, 'container_registry_enabled'=>false,
            'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true,
            'created_at'=>'2017-11-06T12:28:09.720-05:00', 'last_activity_at'=>'2018-02-09T14:21:46.859-05:00', 'shared_runners_enabled'=>false,
            'lfs_enabled'=>true, 'creator_id'=>831,
            'namespace'=>{ 'id'=>1841, 'name'=>'group', 'path'=>'group', 'kind'=>'group', 'full_path'=>'group', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } },
      ]

    end

    it 'gets projects' do
      repo_cred = create :gitlab_cred, created_by: user
      @repo = repo_cred.repo
      Gitlab.stubs(:projects).returns(@gitlab_response2)
      Gitlab.stubs(:file_contents).returns('some file contents')
      projects = @repo.projects repo_cred
      expect(projects.size).to eq 1
    end
  end

  context 'GitHub Stubbed' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      @github_response = [{ id: 103436456,
       name: 'project-baseline',
       full_name: 'username/project-baseline',
       owner:         { login: 'username',
         id: 1000000,
         avatar_url: 'https://avatars3.githubusercontent.com/u/16440?v=4',
         gravatar_id: '',
         url: 'https://api.github.com/users/username',
         html_url: 'https://github.com/username',
         followers_url: 'https://api.github.com/users/username/followers',
         following_url:           'https://api.github.com/users/username/following{/other_user}',
         gists_url: 'https://api.github.com/users/username/gists{/gist_id}',
         starred_url:           'https://api.github.com/users/username/starred{/owner}{/repo}',
         subscriptions_url:           'https://api.github.com/users/username/subscriptions',
         organizations_url: 'https://api.github.com/users/username/orgs',
         repos_url: 'https://api.github.com/users/username/repos',
         events_url: 'https://api.github.com/users/username/events{/privacy}',
         received_events_url:           'https://api.github.com/users/username/received_events',
         type: 'User',
         site_admin: false },
       private: true,
       html_url: 'https://github.com/username/project-baseline',
       description: 'InSpec Profile for the project Application',
       fork: false,
       url: 'https://api.github.com/repos/username/project-baseline',
       forks_url:         'https://api.github.com/repos/username/project-baseline/forks',
       keys_url:         'https://api.github.com/repos/username/project-baseline/keys{/key_id}',
       collaborators_url:         'https://api.github.com/repos/username/project-baseline/collaborators{/collaborator}',
       teams_url:         'https://api.github.com/repos/username/project-baseline/teams',
       hooks_url:         'https://api.github.com/repos/username/project-baseline/hooks',
       issue_events_url:         'https://api.github.com/repos/username/project-baseline/issues/events{/number}',
       events_url:         'https://api.github.com/repos/username/project-baseline/events',
       assignees_url:         'https://api.github.com/repos/username/project-baseline/assignees{/user}',
       branches_url:         'https://api.github.com/repos/username/project-baseline/branches{/branch}',
       tags_url: 'https://api.github.com/repos/username/project-baseline/tags',
       blobs_url:         'https://api.github.com/repos/username/project-baseline/git/blobs{/sha}',
       git_tags_url:         'https://api.github.com/repos/username/project-baseline/git/tags{/sha}',
       git_refs_url:         'https://api.github.com/repos/username/project-baseline/git/refs{/sha}',
       trees_url:         'https://api.github.com/repos/username/project-baseline/git/trees{/sha}',
       statuses_url:         'https://api.github.com/repos/username/project-baseline/statuses/{sha}',
       languages_url:         'https://api.github.com/repos/username/project-baseline/languages',
       stargazers_url:         'https://api.github.com/repos/username/project-baseline/stargazers',
       contributors_url:         'https://api.github.com/repos/username/project-baseline/contributors',
       subscribers_url:         'https://api.github.com/repos/username/project-baseline/subscribers',
       subscription_url:         'https://api.github.com/repos/username/project-baseline/subscription',
       commits_url:         'https://api.github.com/repos/username/project-baseline/commits{/sha}',
       git_commits_url:         'https://api.github.com/repos/username/project-baseline/git/commits{/sha}',
       comments_url:         'https://api.github.com/repos/username/project-baseline/comments{/number}',
       issue_comment_url:         'https://api.github.com/repos/username/project-baseline/issues/comments{/number}',
       contents_url:         'https://api.github.com/repos/username/project-baseline/contents/{+path}',
       compare_url:         'https://api.github.com/repos/username/project-baseline/compare/{base}...{head}',
       merges_url:         'https://api.github.com/repos/username/project-baseline/merges',
       archive_url:         'https://api.github.com/repos/username/project-baseline/{archive_format}{/ref}',
       downloads_url:         'https://api.github.com/repos/username/project-baseline/downloads',
       issues_url:         'https://api.github.com/repos/username/project-baseline/issues{/number}',
       pulls_url:         'https://api.github.com/repos/username/project-baseline/pulls{/number}',
       milestones_url:         'https://api.github.com/repos/username/project-baseline/milestones{/number}',
       notifications_url:         'https://api.github.com/repos/username/project-baseline/notifications{?since,all,participating}',
       labels_url:         'https://api.github.com/repos/username/project-baseline/labels{/name}',
       releases_url:         'https://api.github.com/repos/username/project-baseline/releases{/id}',
       deployments_url:         'https://api.github.com/repos/username/project-baseline/deployments',
       created_at: '2017-09-13 18:31:56 UTC',
       updated_at: '2017-09-13 18:40:15 UTC',
       pushed_at: '2017-09-13 19:11:01 UTC',
       git_url: 'git://github.com/username/project-baseline.git',
       ssh_url: 'git@github.com:username/project-baseline.git',
       clone_url: 'https://github.com/username/project-baseline.git',
       svn_url: 'https://github.com/username/project-baseline',
       homepage: '',
       size: 6,
       stargazers_count: 0,
       watchers_count: 0,
       language: 'Ruby',
       has_issues: true,
       has_projects: true,
       has_downloads: true,
       has_wiki: true,
       has_pages: false,
       forks_count: 0,
       mirror_url: nil,
       archived: false,
       open_issues_count: 0,
       license:         { key: 'apache-2.0',
         name: 'Apache License 2.0',
         spdx_id: 'Apache-2.0',
         url: 'https://api.github.com/licenses/apache-2.0' },
       forks: 0,
       open_issues: 0,
       watchers: 0,
       default_branch: 'master',
       permissions: { admin: false, push: true, pull: true } },
                          { id: 100000000,
                          name: 'mongodb-baseline',
                          full_name: 'username/mongodb-baseline',
                          owner:                            { login: 'username',
                            id: 1000000,
                            avatar_url: 'https://avatars3.githubusercontent.com/u/1000000?v=4',
                            gravatar_id: '',
                            url: 'https://api.github.com/users/username',
                            html_url: 'https://github.com/username',
                            followers_url: 'https://api.github.com/users/username/followers',
                            following_url:                              'https://api.github.com/users/username/following{/other_user}',
                            gists_url: 'https://api.github.com/users/username/gists{/gist_id}',
                            starred_url:                              'https://api.github.com/users/username/starred{/owner}{/repo}',
                            subscriptions_url:                              'https://api.github.com/users/username/subscriptions',
                            organizations_url: 'https://api.github.com/users/username/orgs',
                            repos_url: 'https://api.github.com/users/username/repos',
                            events_url: 'https://api.github.com/users/username/events{/privacy}',
                            received_events_url:                              'https://api.github.com/users/username/received_events',
                            type: 'User',
                            site_admin: false },
                          private: true,
                          html_url: 'https://github.com/username/mongodb-baseline',
                          description: nil,
                          fork: false,
                          url: 'https://api.github.com/repos/username/mongodb-baseline',
                          forks_url:                            'https://api.github.com/repos/username/mongodb-baseline/forks',
                          keys_url:                            'https://api.github.com/repos/username/mongodb-baseline/keys{/key_id}',
                          collaborators_url:                            'https://api.github.com/repos/username/mongodb-baseline/collaborators{/collaborator}',
                          teams_url:                            'https://api.github.com/repos/username/mongodb-baseline/teams',
                          hooks_url:                            'https://api.github.com/repos/username/mongodb-baseline/hooks',
                          issue_events_url:                            'https://api.github.com/repos/username/mongodb-baseline/issues/events{/number}',
                          events_url:                            'https://api.github.com/repos/username/mongodb-baseline/events',
                          assignees_url:                            'https://api.github.com/repos/username/mongodb-baseline/assignees{/user}',
                          branches_url:                            'https://api.github.com/repos/username/mongodb-baseline/branches{/branch}',
                          tags_url: 'https://api.github.com/repos/username/mongodb-baseline/tags',
                          blobs_url:                            'https://api.github.com/repos/username/mongodb-baseline/git/blobs{/sha}',
                          git_tags_url:                            'https://api.github.com/repos/username/mongodb-baseline/git/tags{/sha}',
                          git_refs_url:                            'https://api.github.com/repos/username/mongodb-baseline/git/refs{/sha}',
                          trees_url:                            'https://api.github.com/repos/username/mongodb-baseline/git/trees{/sha}',
                          statuses_url:                            'https://api.github.com/repos/username/mongodb-baseline/statuses/{sha}',
                          languages_url:                            'https://api.github.com/repos/username/mongodb-baseline/languages',
                          stargazers_url:                            'https://api.github.com/repos/username/mongodb-baseline/stargazers',
                          contributors_url:                            'https://api.github.com/repos/username/mongodb-baseline/contributors',
                          subscribers_url:                            'https://api.github.com/repos/username/mongodb-baseline/subscribers',
                          subscription_url:                            'https://api.github.com/repos/username/mongodb-baseline/subscription',
                          commits_url:                            'https://api.github.com/repos/username/mongodb-baseline/commits{/sha}',
                          git_commits_url:                            'https://api.github.com/repos/username/mongodb-baseline/git/commits{/sha}',
                          comments_url:                            'https://api.github.com/repos/username/mongodb-baseline/comments{/number}',
                          issue_comment_url:                            'https://api.github.com/repos/username/mongodb-baseline/issues/comments{/number}',
                          contents_url:                            'https://api.github.com/repos/username/mongodb-baseline/contents/{+path}',
                          compare_url:                            'https://api.github.com/repos/username/mongodb-baseline/compare/{base}...{head}',
                          merges_url:                            'https://api.github.com/repos/username/mongodb-baseline/merges',
                          archive_url:                            'https://api.github.com/repos/username/mongodb-baseline/{archive_format}{/ref}',
                          downloads_url:                            'https://api.github.com/repos/username/mongodb-baseline/downloads',
                          issues_url:                            'https://api.github.com/repos/username/mongodb-baseline/issues{/number}',
                          pulls_url:                            'https://api.github.com/repos/username/mongodb-baseline/pulls{/number}',
                          milestones_url:                            'https://api.github.com/repos/username/mongodb-baseline/milestones{/number}',
                          notifications_url:                            'https://api.github.com/repos/username/mongodb-baseline/notifications{?since,all,participating}',
                          labels_url:                            'https://api.github.com/repos/username/mongodb-baseline/labels{/name}',
                          releases_url:                            'https://api.github.com/repos/username/mongodb-baseline/releases{/id}',
                          deployments_url:                            'https://api.github.com/repos/username/mongodb-baseline/deployments',
                          created_at: '2017-09-14 20:23:44 UTC',
                          updated_at: '2017-09-14 20:23:44 UTC',
                          pushed_at: '2017-09-14 20:23:45 UTC',
                          git_url: 'git://github.com/username/mongodb-baseline.git',
                          ssh_url: 'git@github.com:username/mongodb-baseline.git',
                          clone_url: 'https://github.com/username/mongodb-baseline.git',
                          svn_url: 'https://github.com/username/mongodb-baseline',
                          homepage: nil,
                          size: 5,
                          stargazers_count: 0,
                          watchers_count: 0,
                          language: nil,
                          has_issues: true,
                          has_projects: true,
                          has_downloads: true,
                          has_wiki: true,
                          has_pages: false,
                          forks_count: 0,
                          mirror_url: nil,
                          archived: false,
                          open_issues_count: 0,
                          license:                            { key: 'apache-2.0',
                            name: 'Apache License 2.0',
                            spdx_id: 'Apache-2.0',
                            url: 'https://api.github.com/licenses/apache-2.0' },
                          forks: 0,
                          open_issues: 0,
                          watchers: 0,
                          default_branch: 'master',
                          permissions: { admin: false, push: true, pull: true } },
                          { id: 90000000,
                          name: 'nginx-baseline',
                          full_name: 'username/nginx-baseline',
                          owner:                            { login: 'username',
                            id: 1000000,
                            avatar_url: 'https://avatars3.githubusercontent.com/u/1000000?v=4',
                            gravatar_id: '',
                            url: 'https://api.github.com/users/username',
                            html_url: 'https://github.com/username',
                            followers_url: 'https://api.github.com/users/username/followers',
                            following_url:                              'https://api.github.com/users/username/following{/other_user}',
                            gists_url: 'https://api.github.com/users/username/gists{/gist_id}',
                            starred_url:                              'https://api.github.com/users/username/starred{/owner}{/repo}',
                            subscriptions_url:                              'https://api.github.com/users/username/subscriptions',
                            organizations_url: 'https://api.github.com/users/username/orgs',
                            repos_url: 'https://api.github.com/users/username/repos',
                            events_url: 'https://api.github.com/users/username/events{/privacy}',
                            received_events_url:                              'https://api.github.com/users/username/received_events',
                            type: 'User',
                            site_admin: false },
                          private: false,
                          html_url: 'https://github.com/username/nginx-baseline',
                          description: 'DevSec Nginx Baseline - InSpec Profile',
                          fork: true,
                          url: 'https://api.github.com/repos/username/nginx-baseline',
                          forks_url: 'https://api.github.com/repos/username/nginx-baseline/forks',
                          keys_url:                            'https://api.github.com/repos/username/nginx-baseline/keys{/key_id}',
                          collaborators_url:                            'https://api.github.com/repos/username/nginx-baseline/collaborators{/collaborator}',
                          teams_url: 'https://api.github.com/repos/username/nginx-baseline/teams',
                          hooks_url: 'https://api.github.com/repos/username/nginx-baseline/hooks',
                          issue_events_url:                            'https://api.github.com/repos/username/nginx-baseline/issues/events{/number}',
                          events_url:                            'https://api.github.com/repos/username/nginx-baseline/events',
                          assignees_url:                            'https://api.github.com/repos/username/nginx-baseline/assignees{/user}',
                          branches_url:                            'https://api.github.com/repos/username/nginx-baseline/branches{/branch}',
                          tags_url: 'https://api.github.com/repos/username/nginx-baseline/tags',
                          blobs_url:                            'https://api.github.com/repos/username/nginx-baseline/git/blobs{/sha}',
                          git_tags_url:                            'https://api.github.com/repos/username/nginx-baseline/git/tags{/sha}',
                          git_refs_url:                            'https://api.github.com/repos/username/nginx-baseline/git/refs{/sha}',
                          trees_url:                            'https://api.github.com/repos/username/nginx-baseline/git/trees{/sha}',
                          statuses_url:                            'https://api.github.com/repos/username/nginx-baseline/statuses/{sha}',
                          languages_url:                            'https://api.github.com/repos/username/nginx-baseline/languages',
                          stargazers_url:                            'https://api.github.com/repos/username/nginx-baseline/stargazers',
                          contributors_url:                            'https://api.github.com/repos/username/nginx-baseline/contributors',
                          subscribers_url:                            'https://api.github.com/repos/username/nginx-baseline/subscribers',
                          subscription_url:                            'https://api.github.com/repos/username/nginx-baseline/subscription',
                          commits_url:                            'https://api.github.com/repos/username/nginx-baseline/commits{/sha}',
                          git_commits_url:                            'https://api.github.com/repos/username/nginx-baseline/git/commits{/sha}',
                          comments_url:                            'https://api.github.com/repos/username/nginx-baseline/comments{/number}',
                          issue_comment_url:                            'https://api.github.com/repos/username/nginx-baseline/issues/comments{/number}',
                          contents_url:                            'https://api.github.com/repos/username/nginx-baseline/contents/{+path}',
                          compare_url:                            'https://api.github.com/repos/username/nginx-baseline/compare/{base}...{head}',
                          merges_url:                            'https://api.github.com/repos/username/nginx-baseline/merges',
                          archive_url:                            'https://api.github.com/repos/username/nginx-baseline/{archive_format}{/ref}',
                          downloads_url:                            'https://api.github.com/repos/username/nginx-baseline/downloads',
                          issues_url:                            'https://api.github.com/repos/username/nginx-baseline/issues{/number}',
                          pulls_url:                            'https://api.github.com/repos/username/nginx-baseline/pulls{/number}',
                          milestones_url:                            'https://api.github.com/repos/username/nginx-baseline/milestones{/number}',
                          notifications_url:                            'https://api.github.com/repos/username/nginx-baseline/notifications{?since,all,participating}',
                          labels_url:                            'https://api.github.com/repos/username/nginx-baseline/labels{/name}',
                          releases_url:                            'https://api.github.com/repos/username/nginx-baseline/releases{/id}',
                          deployments_url:                            'https://api.github.com/repos/username/nginx-baseline/deployments',
                          created_at: '2017-06-01 20:31:02 UTC',
                          updated_at: '2018-03-21 14:58:48 UTC',
                          pushed_at: '2018-03-21 14:58:47 UTC',
                          git_url: 'git://github.com/username/nginx-baseline.git',
                          ssh_url: 'git@github.com:username/nginx-baseline.git',
                          clone_url: 'https://github.com/username/nginx-baseline.git',
                          svn_url: 'https://github.com/username/nginx-baseline',
                          homepage: 'http://dev-sec.io/',
                          size: 213,
                          stargazers_count: 2,
                          watchers_count: 2,
                          language: 'Ruby',
                          has_issues: true,
                          has_projects: true,
                          has_downloads: true,
                          has_wiki: true,
                          has_pages: false,
                          forks_count: 1,
                          mirror_url: nil,
                          archived: false,
                          open_issues_count: 0,
                          license:                            { key: 'apache-2.0',
                            name: 'Apache License 2.0',
                            spdx_id: 'Apache-2.0',
                            url: 'https://api.github.com/licenses/apache-2.0' },
                          forks: 1,
                          open_issues: 0,
                          watchers: 2,
                          default_branch: 'master',
                          permissions: { admin: false, push: true, pull: true } }]

    end

    it 'gets projects' do
      repo_cred = create :github_cred, created_by: user
      @repo = repo_cred.repo
      Octokit::Client.stubs(:new).returns(ClientStub.new)
      # Octokit::Client.any_instance.stubs(:repos).returns(@github_response)
      # Octokit::Client.any_instance.stubs(:contents).returns('some file contents')
      projects = @repo.projects repo_cred
      expect(projects).to_not be_empty
    end

    it 'finds no inspec projects' do
      repo_cred = create :github_cred, created_by: user
      @repo = repo_cred.repo
      Octokit::Client.stubs(:new).returns(ClientStub.new)
      ClientStub.any_instance.stubs(:contents).raises(Octokit::NotFound)
      # Octokit::Client.any_instance.stubs(:contents).returns('some file contents')
      projects = @repo.projects repo_cred
      expect(projects).to be_empty
    end

    it 'gets no projects' do
      repo_cred = create :github_cred, created_by: user
      @repo = repo_cred.repo
      Octokit::Client.stubs(:new).returns(ClientStub.new)
      ClientStub.any_instance.stubs(:repos).raises(NoMethodError)
      # Octokit::Client.any_instance.stubs(:contents).returns('some file contents')
      projects = @repo.projects repo_cred
      expect(projects).to be_empty
    end
  end
end

class ClientStub
  @response = '[{"id": 103436456,
   "name": "project-baseline",
   "full_name": "username/project-baseline",
   "owner":
    {"login": "username",
     "id": 1000000,
     "avatar_url": "https://avatars3.githubusercontent.com/u/14840?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/username",
     "html_url": "https://github.com/username",
     "followers_url": "https://api.github.com/users/username/followers",
     "following_url":
      "https://api.github.com/users/username/following{/other_user}",
     "gists_url": "https://api.github.com/users/username/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/username/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/username/subscriptions",
     "organizations_url": "https://api.github.com/users/username/orgs",
     "repos_url": "https://api.github.com/users/username/repos",
     "events_url": "https://api.github.com/users/username/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/username/received_events",
     "type": "User",
     "site_admin": false},
   "private": true,
   "html_url": "https://github.com/username/project-baseline",
   "description": "Profile for the project Application",
   "fork": false,
   "url": "https://api.github.com/repos/username/project-baseline",
   "forks_url":
    "https://api.github.com/repos/username/project-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/username/project-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/username/project-baseline/collaborators{/collaborator}",
   "teams_url":
    "https://api.github.com/repos/username/project-baseline/teams",
   "hooks_url":
    "https://api.github.com/repos/username/project-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/username/project-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/username/project-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/username/project-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/username/project-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/username/project-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/username/project-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/username/project-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/username/project-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/username/project-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/username/project-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/username/project-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/username/project-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/username/project-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/username/project-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/username/project-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/username/project-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/username/project-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/username/project-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/username/project-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/username/project-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/username/project-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/username/project-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/username/project-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/username/project-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/username/project-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/username/project-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/username/project-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/username/project-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/username/project-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/username/project-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/username/project-baseline/deployments",
   "git_url": "git://github.com/username/project-baseline.git",
   "ssh_url": "git@github.com:username/project-baseline.git",
   "clone_url": "https://github.com/username/project-baseline.git",
   "svn_url": "https://github.com/username/project-baseline",
   "homepage": "",
   "size": 6,
   "stargazers_count": 0,
   "watchers_count": 0,
   "language": "Ruby",
   "has_issues": true,
   "has_projects": true,
   "has_downloads": true,
   "has_wiki": true,
   "has_pages": false,
   "forks_count": 0,
   "archived": false,
   "open_issues_count": 0,
   "license":
    {"key": "apache-2.0",
     "name": "Apache License 2.0",
     "spdx_id": "Apache-2.0",
     "url": "https://api.github.com/licenses/apache-2.0"},
   "forks": 0,
   "open_issues": 0,
   "watchers": 0,
   "default_branch": "master",
   "permissions": {"admin": false, "push": true, "pull": true}},
   {"id": 100000000,
   "name": "mongodb-baseline",
   "full_name": "username/mongodb-baseline",
   "owner":
    {"login": "username",
     "id": 1000000,
     "avatar_url": "https://avatars3.githubusercontent.com/u/14840?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/username",
     "html_url": "https://github.com/username",
     "followers_url": "https://api.github.com/users/username/followers",
     "following_url":
      "https://api.github.com/users/username/following{/other_user}",
     "gists_url": "https://api.github.com/users/username/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/username/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/username/subscriptions",
     "organizations_url": "https://api.github.com/users/username/orgs",
     "repos_url": "https://api.github.com/users/username/repos",
     "events_url": "https://api.github.com/users/username/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/username/received_events",
     "type": "User",
     "site_admin": false},
   "private": true,
   "html_url": "https://github.com/username/mongodb-baseline",
   "fork": false,
   "url": "https://api.github.com/repos/username/mongodb-baseline",
   "forks_url":
    "https://api.github.com/repos/username/mongodb-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/username/mongodb-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/username/mongodb-baseline/collaborators{/collaborator}",
   "teams_url":
    "https://api.github.com/repos/username/mongodb-baseline/teams",
   "hooks_url":
    "https://api.github.com/repos/username/mongodb-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/username/mongodb-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/username/mongodb-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/username/mongodb-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/username/mongodb-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/username/mongodb-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/username/mongodb-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/username/mongodb-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/username/mongodb-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/username/mongodb-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/username/mongodb-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/username/mongodb-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/username/mongodb-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/username/mongodb-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/username/mongodb-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/username/mongodb-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/username/mongodb-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/username/mongodb-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/username/mongodb-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/username/mongodb-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/username/mongodb-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/username/mongodb-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/username/mongodb-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/username/mongodb-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/username/mongodb-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/username/mongodb-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/username/mongodb-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/username/mongodb-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/username/mongodb-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/username/mongodb-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/username/mongodb-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/username/mongodb-baseline/deployments",
   "git_url": "git://github.com/username/mongodb-baseline.git",
   "ssh_url": "git@github.com:username/mongodb-baseline.git",
   "clone_url": "https://github.com/username/mongodb-baseline.git",
   "svn_url": "https://github.com/username/mongodb-baseline",
   "size": 5,
   "stargazers_count": 0,
   "watchers_count": 0,
   "has_issues": true,
   "has_projects": true,
   "has_downloads": true,
   "has_wiki": true,
   "has_pages": false,
   "forks_count": 0,
   "archived": false,
   "open_issues_count": 0,
   "license":
    {"key": "apache-2.0",
     "name": "Apache License 2.0",
     "spdx_id": "Apache-2.0",
     "url": "https://api.github.com/licenses/apache-2.0"},
   "forks": 0,
   "open_issues": 0,
   "watchers": 0,
   "default_branch": "master",
   "permissions": {"admin": false, "push": true, "pull": true}},
   {"id": 90000000,
   "name": "nginx-baseline",
   "full_name": "username/baseline",
   "owner":
    {"login": "username",
     "id": 1000000,
     "avatar_url": "https://avatars3.githubusercontent.com/u/1000000?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/username",
     "html_url": "https://github.com/username",
     "followers_url": "https://api.github.com/users/username/followers",
     "following_url":
      "https://api.github.com/users/username/following{/other_user}",
     "gists_url": "https://api.github.com/users/username/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/username/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/username/subscriptions",
     "organizations_url": "https://api.github.com/users/username/orgs",
     "repos_url": "https://api.github.com/users/username/repos",
     "events_url": "https://api.github.com/users/username/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/username/received_events",
     "type": "User",
     "site_admin": false},
   "private": false,
   "html_url": "https://github.com/username/nginx-baseline",
   "description": "Profile",
   "fork": true,
   "url": "https://api.github.com/repos/username/nginx-baseline",
   "forks_url": "https://api.github.com/repos/username/nginx-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/username/nginx-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/username/nginx-baseline/collaborators{/collaborator}",
   "teams_url": "https://api.github.com/repos/username/nginx-baseline/teams",
   "hooks_url": "https://api.github.com/repos/username/nginx-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/username/nginx-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/username/nginx-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/username/nginx-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/username/nginx-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/username/nginx-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/username/nginx-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/username/nginx-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/username/nginx-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/username/nginx-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/username/nginx-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/username/nginx-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/username/nginx-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/username/nginx-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/username/nginx-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/username/nginx-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/username/nginx-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/username/nginx-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/username/nginx-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/username/nginx-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/username/nginx-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/username/nginx-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/username/nginx-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/username/nginx-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/username/nginx-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/username/nginx-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/username/nginx-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/username/nginx-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/username/nginx-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/username/nginx-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/username/nginx-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/username/nginx-baseline/deployments",
   "git_url": "git://github.com/username/nginx-baseline.git",
   "ssh_url": "git@github.com:username/nginx-baseline.git",
   "clone_url": "https://github.com/username/nginx-baseline.git",
   "svn_url": "https://github.com/username/nginx-baseline",
   "homepage": "http://dev-sec.io/",
   "size": 213,
   "stargazers_count": 2,
   "watchers_count": 2,
   "language": "Ruby",
   "has_issues": true,
   "has_projects": true,
   "has_downloads": true,
   "has_wiki": true,
   "has_pages": false,
   "forks_count": 1,
   "archived": false,
   "open_issues_count": 0,
   "license":
    {"key": "apache-2.0",
     "name": "Apache License 2.0",
     "spdx_id": "Apache-2.0",
     "url": "https://api.github.com/licenses/apache-2.0"},
   "forks": 1,
   "open_issues": 0,
   "watchers": 2,
   "default_branch": "master",
   "permissions": {"admin": false, "push": true, "pull": true}}
  ]'

  class << self
    attr_accessor :response
  end

  def repos
    JSON.parse(ClientStub.response, object_class: OpenStruct)
  end

  def contents(_repo, _path)
    'some file contents'
  end
end
