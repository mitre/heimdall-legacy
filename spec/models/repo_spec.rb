require 'rails_helper'

RSpec.describe Repo, type: :model do
  it { is_expected.to be_mongoid_document }

  context 'GitLab Stubbed' do
    let(:user) { FactoryGirl.create(:editor) }
    before do
      @gitlab_response = [
        { hash:
          { 'id'=>12187, 'description'=>'experimental cli client for cascade', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true,
            'archived'=>false, 'visibility_level'=>20, 'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/cascade-cli.git',
            'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/cascade-cli.git', 'web_url'=>'https://gitlab.mitre.org/cascade/cascade-cli',
            'name'=>'cascade-cli', 'name_with_namespace'=>'CASCADE / cascade-cli', 'path'=>'cascade-cli', 'path_with_namespace'=>'cascade/cascade-cli',
            'resolve_outdated_diff_discussions'=>false, 'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true,
            'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true, 'created_at'=>'2017-12-07T00:50:11.441-05:00',
            'last_activity_at'=>'2017-12-07T00:50:11.441-05:00', 'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
        { hash:
          { 'id'=>11892, 'description'=>'', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true, 'archived'=>false, 'visibility_level'=>20,
            'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/cascade3-server.git', 'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/cascade3-server.git',
            'web_url'=>'https://gitlab.mitre.org/cascade/cascade3-server', 'name'=>'cascade3-server', 'name_with_namespace'=>'CASCADE / cascade3-server',
            'path'=>'cascade3-server', 'path_with_namespace'=>'cascade/cascade3-server', 'resolve_outdated_diff_discussions'=>nil,
            'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true,
            'snippets_enabled'=>true, 'created_at'=>'2017-11-07T14:00:29.084-05:00', 'last_activity_at'=>'2018-03-22T18:36:30.507-04:00',
            'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
            'avatar_url'=>'https://gitlab.mitre.org/uploads/-/system/project/avatar/11892/cascade-1853341_960_720.jpg', 'star_count'=>2, 'forks_count'=>0,
            'open_issues_count'=>87, 'public_builds'=>true, 'shared_with_groups'=>[], 'only_allow_merge_if_build_succeeds'=>false,
            'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
        { hash:
          { 'id'=>11870, 'description'=>'Pull BRAWL data from ES and add to (dockerized) Splunk.', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>false,
            'archived'=>false, 'visibility_level'=>0, 'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/BRAWL-to-Splunk.git',
            'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/BRAWL-to-Splunk.git', 'web_url'=>'https://gitlab.mitre.org/cascade/BRAWL-to-Splunk',
            'name'=>'BRAWL-to-Splunk', 'name_with_namespace'=>'CASCADE / BRAWL-to-Splunk', 'path'=>'BRAWL-to-Splunk',
            'path_with_namespace'=>'cascade/BRAWL-to-Splunk', 'resolve_outdated_diff_discussions'=>nil, 'container_registry_enabled'=>false,
            'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true,
            'created_at'=>'2017-11-06T12:28:09.720-05:00', 'last_activity_at'=>'2018-02-09T14:21:46.859-05:00', 'shared_runners_enabled'=>false,
            'lfs_enabled'=>true, 'creator_id'=>831,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } } },
      ]

      @gitlab_response2 = [
        { 'id'=>12187, 'description'=>'experimental cli client for cascade', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true,
            'archived'=>false, 'visibility_level'=>20, 'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/cascade-cli.git',
            'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/cascade-cli.git', 'web_url'=>'https://gitlab.mitre.org/cascade/cascade-cli',
            'name'=>'cascade-cli', 'name_with_namespace'=>'CASCADE / cascade-cli', 'path'=>'cascade-cli', 'path_with_namespace'=>'cascade/cascade-cli',
            'resolve_outdated_diff_discussions'=>false, 'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true,
            'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true, 'created_at'=>'2017-12-07T00:50:11.441-05:00',
            'last_activity_at'=>'2017-12-07T00:50:11.441-05:00', 'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
            'avatar_url'=>nil, 'star_count'=>0, 'forks_count'=>0, 'open_issues_count'=>0, 'public_builds'=>true, 'shared_with_groups'=>[],
            'only_allow_merge_if_build_succeeds'=>false, 'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } },
        { 'id'=>11892, 'description'=>'', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>true, 'archived'=>false, 'visibility_level'=>20,
            'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/cascade3-server.git', 'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/cascade3-server.git',
            'web_url'=>'https://gitlab.mitre.org/cascade/cascade3-server', 'name'=>'cascade3-server', 'name_with_namespace'=>'CASCADE / cascade3-server',
            'path'=>'cascade3-server', 'path_with_namespace'=>'cascade/cascade3-server', 'resolve_outdated_diff_discussions'=>nil,
            'container_registry_enabled'=>false, 'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true,
            'snippets_enabled'=>true, 'created_at'=>'2017-11-07T14:00:29.084-05:00', 'last_activity_at'=>'2018-03-22T18:36:30.507-04:00',
            'shared_runners_enabled'=>false, 'lfs_enabled'=>true, 'creator_id'=>1133,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
            'avatar_url'=>'https://gitlab.mitre.org/uploads/-/system/project/avatar/11892/cascade-1853341_960_720.jpg', 'star_count'=>2, 'forks_count'=>0,
            'open_issues_count'=>87, 'public_builds'=>true, 'shared_with_groups'=>[], 'only_allow_merge_if_build_succeeds'=>false,
            'request_access_enabled'=>false, 'only_allow_merge_if_all_discussions_are_resolved'=>false,
            'permissions'=>{ 'project_access'=>nil, 'group_access'=>{ 'access_level'=>30, 'notification_level'=>3 } } },
        { 'id'=>11870, 'description'=>'Pull BRAWL data from ES and add to (dockerized) Splunk.', 'default_branch'=>'master', 'tag_list'=>[], 'public'=>false,
            'archived'=>false, 'visibility_level'=>0, 'ssh_url_to_repo'=>'git@gitlab.mitre.org:cascade/BRAWL-to-Splunk.git',
            'http_url_to_repo'=>'https://gitlab.mitre.org/cascade/BRAWL-to-Splunk.git', 'web_url'=>'https://gitlab.mitre.org/cascade/BRAWL-to-Splunk',
            'name'=>'BRAWL-to-Splunk', 'name_with_namespace'=>'CASCADE / BRAWL-to-Splunk', 'path'=>'BRAWL-to-Splunk',
            'path_with_namespace'=>'cascade/BRAWL-to-Splunk', 'resolve_outdated_diff_discussions'=>nil, 'container_registry_enabled'=>false,
            'issues_enabled'=>true, 'merge_requests_enabled'=>true, 'wiki_enabled'=>true, 'builds_enabled'=>true, 'snippets_enabled'=>true,
            'created_at'=>'2017-11-06T12:28:09.720-05:00', 'last_activity_at'=>'2018-02-09T14:21:46.859-05:00', 'shared_runners_enabled'=>false,
            'lfs_enabled'=>true, 'creator_id'=>831,
            'namespace'=>{ 'id'=>1841, 'name'=>'CASCADE', 'path'=>'cascade', 'kind'=>'group', 'full_path'=>'cascade', 'parent_id'=>nil },
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
    let(:user) { FactoryGirl.create(:editor) }
    before do
      @github_response = [{ id: 103436456,
       name: 'heimdall-baseline',
       full_name: 'aaronlippold/heimdall-baseline',
       owner:         { login: 'aaronlippold',
         id: 1486440,
         avatar_url: 'https://avatars3.githubusercontent.com/u/1486440?v=4',
         gravatar_id: '',
         url: 'https://api.github.com/users/aaronlippold',
         html_url: 'https://github.com/aaronlippold',
         followers_url: 'https://api.github.com/users/aaronlippold/followers',
         following_url:           'https://api.github.com/users/aaronlippold/following{/other_user}',
         gists_url: 'https://api.github.com/users/aaronlippold/gists{/gist_id}',
         starred_url:           'https://api.github.com/users/aaronlippold/starred{/owner}{/repo}',
         subscriptions_url:           'https://api.github.com/users/aaronlippold/subscriptions',
         organizations_url: 'https://api.github.com/users/aaronlippold/orgs',
         repos_url: 'https://api.github.com/users/aaronlippold/repos',
         events_url: 'https://api.github.com/users/aaronlippold/events{/privacy}',
         received_events_url:           'https://api.github.com/users/aaronlippold/received_events',
         type: 'User',
         site_admin: false },
       private: true,
       html_url: 'https://github.com/aaronlippold/heimdall-baseline',
       description: 'InSpec Profile for the Heimdall Application',
       fork: false,
       url: 'https://api.github.com/repos/aaronlippold/heimdall-baseline',
       forks_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/forks',
       keys_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/keys{/key_id}',
       collaborators_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/collaborators{/collaborator}',
       teams_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/teams',
       hooks_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/hooks',
       issue_events_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/issues/events{/number}',
       events_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/events',
       assignees_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/assignees{/user}',
       branches_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/branches{/branch}',
       tags_url: 'https://api.github.com/repos/aaronlippold/heimdall-baseline/tags',
       blobs_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/git/blobs{/sha}',
       git_tags_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/git/tags{/sha}',
       git_refs_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/git/refs{/sha}',
       trees_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/git/trees{/sha}',
       statuses_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/statuses/{sha}',
       languages_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/languages',
       stargazers_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/stargazers',
       contributors_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/contributors',
       subscribers_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/subscribers',
       subscription_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/subscription',
       commits_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/commits{/sha}',
       git_commits_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/git/commits{/sha}',
       comments_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/comments{/number}',
       issue_comment_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/issues/comments{/number}',
       contents_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/contents/{+path}',
       compare_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/compare/{base}...{head}',
       merges_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/merges',
       archive_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/{archive_format}{/ref}',
       downloads_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/downloads',
       issues_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/issues{/number}',
       pulls_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/pulls{/number}',
       milestones_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/milestones{/number}',
       notifications_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/notifications{?since,all,participating}',
       labels_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/labels{/name}',
       releases_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/releases{/id}',
       deployments_url:         'https://api.github.com/repos/aaronlippold/heimdall-baseline/deployments',
       created_at: '2017-09-13 18:31:56 UTC',
       updated_at: '2017-09-13 18:40:15 UTC',
       pushed_at: '2017-09-13 19:11:01 UTC',
       git_url: 'git://github.com/aaronlippold/heimdall-baseline.git',
       ssh_url: 'git@github.com:aaronlippold/heimdall-baseline.git',
       clone_url: 'https://github.com/aaronlippold/heimdall-baseline.git',
       svn_url: 'https://github.com/aaronlippold/heimdall-baseline',
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
                          { id: 103578043,
                          name: 'mongodb-baseline',
                          full_name: 'aaronlippold/mongodb-baseline',
                          owner:                            { login: 'aaronlippold',
                            id: 1486440,
                            avatar_url: 'https://avatars3.githubusercontent.com/u/1486440?v=4',
                            gravatar_id: '',
                            url: 'https://api.github.com/users/aaronlippold',
                            html_url: 'https://github.com/aaronlippold',
                            followers_url: 'https://api.github.com/users/aaronlippold/followers',
                            following_url:                              'https://api.github.com/users/aaronlippold/following{/other_user}',
                            gists_url: 'https://api.github.com/users/aaronlippold/gists{/gist_id}',
                            starred_url:                              'https://api.github.com/users/aaronlippold/starred{/owner}{/repo}',
                            subscriptions_url:                              'https://api.github.com/users/aaronlippold/subscriptions',
                            organizations_url: 'https://api.github.com/users/aaronlippold/orgs',
                            repos_url: 'https://api.github.com/users/aaronlippold/repos',
                            events_url: 'https://api.github.com/users/aaronlippold/events{/privacy}',
                            received_events_url:                              'https://api.github.com/users/aaronlippold/received_events',
                            type: 'User',
                            site_admin: false },
                          private: true,
                          html_url: 'https://github.com/aaronlippold/mongodb-baseline',
                          description: nil,
                          fork: false,
                          url: 'https://api.github.com/repos/aaronlippold/mongodb-baseline',
                          forks_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/forks',
                          keys_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/keys{/key_id}',
                          collaborators_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/collaborators{/collaborator}',
                          teams_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/teams',
                          hooks_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/hooks',
                          issue_events_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/issues/events{/number}',
                          events_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/events',
                          assignees_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/assignees{/user}',
                          branches_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/branches{/branch}',
                          tags_url: 'https://api.github.com/repos/aaronlippold/mongodb-baseline/tags',
                          blobs_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/git/blobs{/sha}',
                          git_tags_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/git/tags{/sha}',
                          git_refs_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/git/refs{/sha}',
                          trees_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/git/trees{/sha}',
                          statuses_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/statuses/{sha}',
                          languages_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/languages',
                          stargazers_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/stargazers',
                          contributors_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/contributors',
                          subscribers_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/subscribers',
                          subscription_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/subscription',
                          commits_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/commits{/sha}',
                          git_commits_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/git/commits{/sha}',
                          comments_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/comments{/number}',
                          issue_comment_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/issues/comments{/number}',
                          contents_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/contents/{+path}',
                          compare_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/compare/{base}...{head}',
                          merges_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/merges',
                          archive_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/{archive_format}{/ref}',
                          downloads_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/downloads',
                          issues_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/issues{/number}',
                          pulls_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/pulls{/number}',
                          milestones_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/milestones{/number}',
                          notifications_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/notifications{?since,all,participating}',
                          labels_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/labels{/name}',
                          releases_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/releases{/id}',
                          deployments_url:                            'https://api.github.com/repos/aaronlippold/mongodb-baseline/deployments',
                          created_at: '2017-09-14 20:23:44 UTC',
                          updated_at: '2017-09-14 20:23:44 UTC',
                          pushed_at: '2017-09-14 20:23:45 UTC',
                          git_url: 'git://github.com/aaronlippold/mongodb-baseline.git',
                          ssh_url: 'git@github.com:aaronlippold/mongodb-baseline.git',
                          clone_url: 'https://github.com/aaronlippold/mongodb-baseline.git',
                          svn_url: 'https://github.com/aaronlippold/mongodb-baseline',
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
                          { id: 93096930,
                          name: 'nginx-baseline',
                          full_name: 'aaronlippold/nginx-baseline',
                          owner:                            { login: 'aaronlippold',
                            id: 1486440,
                            avatar_url: 'https://avatars3.githubusercontent.com/u/1486440?v=4',
                            gravatar_id: '',
                            url: 'https://api.github.com/users/aaronlippold',
                            html_url: 'https://github.com/aaronlippold',
                            followers_url: 'https://api.github.com/users/aaronlippold/followers',
                            following_url:                              'https://api.github.com/users/aaronlippold/following{/other_user}',
                            gists_url: 'https://api.github.com/users/aaronlippold/gists{/gist_id}',
                            starred_url:                              'https://api.github.com/users/aaronlippold/starred{/owner}{/repo}',
                            subscriptions_url:                              'https://api.github.com/users/aaronlippold/subscriptions',
                            organizations_url: 'https://api.github.com/users/aaronlippold/orgs',
                            repos_url: 'https://api.github.com/users/aaronlippold/repos',
                            events_url: 'https://api.github.com/users/aaronlippold/events{/privacy}',
                            received_events_url:                              'https://api.github.com/users/aaronlippold/received_events',
                            type: 'User',
                            site_admin: false },
                          private: false,
                          html_url: 'https://github.com/aaronlippold/nginx-baseline',
                          description: 'DevSec Nginx Baseline - InSpec Profile',
                          fork: true,
                          url: 'https://api.github.com/repos/aaronlippold/nginx-baseline',
                          forks_url: 'https://api.github.com/repos/aaronlippold/nginx-baseline/forks',
                          keys_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/keys{/key_id}',
                          collaborators_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/collaborators{/collaborator}',
                          teams_url: 'https://api.github.com/repos/aaronlippold/nginx-baseline/teams',
                          hooks_url: 'https://api.github.com/repos/aaronlippold/nginx-baseline/hooks',
                          issue_events_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/issues/events{/number}',
                          events_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/events',
                          assignees_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/assignees{/user}',
                          branches_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/branches{/branch}',
                          tags_url: 'https://api.github.com/repos/aaronlippold/nginx-baseline/tags',
                          blobs_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/git/blobs{/sha}',
                          git_tags_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/git/tags{/sha}',
                          git_refs_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/git/refs{/sha}',
                          trees_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/git/trees{/sha}',
                          statuses_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/statuses/{sha}',
                          languages_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/languages',
                          stargazers_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/stargazers',
                          contributors_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/contributors',
                          subscribers_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/subscribers',
                          subscription_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/subscription',
                          commits_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/commits{/sha}',
                          git_commits_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/git/commits{/sha}',
                          comments_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/comments{/number}',
                          issue_comment_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/issues/comments{/number}',
                          contents_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/contents/{+path}',
                          compare_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/compare/{base}...{head}',
                          merges_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/merges',
                          archive_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/{archive_format}{/ref}',
                          downloads_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/downloads',
                          issues_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/issues{/number}',
                          pulls_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/pulls{/number}',
                          milestones_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/milestones{/number}',
                          notifications_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/notifications{?since,all,participating}',
                          labels_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/labels{/name}',
                          releases_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/releases{/id}',
                          deployments_url:                            'https://api.github.com/repos/aaronlippold/nginx-baseline/deployments',
                          created_at: '2017-06-01 20:31:02 UTC',
                          updated_at: '2018-03-21 14:58:48 UTC',
                          pushed_at: '2018-03-21 14:58:47 UTC',
                          git_url: 'git://github.com/aaronlippold/nginx-baseline.git',
                          ssh_url: 'git@github.com:aaronlippold/nginx-baseline.git',
                          clone_url: 'https://github.com/aaronlippold/nginx-baseline.git',
                          svn_url: 'https://github.com/aaronlippold/nginx-baseline',
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
   "name": "heimdall-baseline",
   "full_name": "aaronlippold/heimdall-baseline",
   "owner":
    {"login": "aaronlippold",
     "id": 1486440,
     "avatar_url": "https://avatars3.githubusercontent.com/u/1486440?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/aaronlippold",
     "html_url": "https://github.com/aaronlippold",
     "followers_url": "https://api.github.com/users/aaronlippold/followers",
     "following_url":
      "https://api.github.com/users/aaronlippold/following{/other_user}",
     "gists_url": "https://api.github.com/users/aaronlippold/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/aaronlippold/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/aaronlippold/subscriptions",
     "organizations_url": "https://api.github.com/users/aaronlippold/orgs",
     "repos_url": "https://api.github.com/users/aaronlippold/repos",
     "events_url": "https://api.github.com/users/aaronlippold/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/aaronlippold/received_events",
     "type": "User",
     "site_admin": false},
   "private": true,
   "html_url": "https://github.com/aaronlippold/heimdall-baseline",
   "description": "InSpec Profile for the Heimdall Application",
   "fork": false,
   "url": "https://api.github.com/repos/aaronlippold/heimdall-baseline",
   "forks_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/collaborators{/collaborator}",
   "teams_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/teams",
   "hooks_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/aaronlippold/heimdall-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/aaronlippold/heimdall-baseline/deployments",
   "git_url": "git://github.com/aaronlippold/heimdall-baseline.git",
   "ssh_url": "git@github.com:aaronlippold/heimdall-baseline.git",
   "clone_url": "https://github.com/aaronlippold/heimdall-baseline.git",
   "svn_url": "https://github.com/aaronlippold/heimdall-baseline",
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
   {"id": 103578043,
   "name": "mongodb-baseline",
   "full_name": "aaronlippold/mongodb-baseline",
   "owner":
    {"login": "aaronlippold",
     "id": 1486440,
     "avatar_url": "https://avatars3.githubusercontent.com/u/1486440?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/aaronlippold",
     "html_url": "https://github.com/aaronlippold",
     "followers_url": "https://api.github.com/users/aaronlippold/followers",
     "following_url":
      "https://api.github.com/users/aaronlippold/following{/other_user}",
     "gists_url": "https://api.github.com/users/aaronlippold/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/aaronlippold/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/aaronlippold/subscriptions",
     "organizations_url": "https://api.github.com/users/aaronlippold/orgs",
     "repos_url": "https://api.github.com/users/aaronlippold/repos",
     "events_url": "https://api.github.com/users/aaronlippold/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/aaronlippold/received_events",
     "type": "User",
     "site_admin": false},
   "private": true,
   "html_url": "https://github.com/aaronlippold/mongodb-baseline",
   "fork": false,
   "url": "https://api.github.com/repos/aaronlippold/mongodb-baseline",
   "forks_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/collaborators{/collaborator}",
   "teams_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/teams",
   "hooks_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/aaronlippold/mongodb-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/aaronlippold/mongodb-baseline/deployments",
   "git_url": "git://github.com/aaronlippold/mongodb-baseline.git",
   "ssh_url": "git@github.com:aaronlippold/mongodb-baseline.git",
   "clone_url": "https://github.com/aaronlippold/mongodb-baseline.git",
   "svn_url": "https://github.com/aaronlippold/mongodb-baseline",
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
   {"id": 93096930,
   "name": "nginx-baseline",
   "full_name": "aaronlippold/nginx-baseline",
   "owner":
    {"login": "aaronlippold",
     "id": 1486440,
     "avatar_url": "https://avatars3.githubusercontent.com/u/1486440?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/aaronlippold",
     "html_url": "https://github.com/aaronlippold",
     "followers_url": "https://api.github.com/users/aaronlippold/followers",
     "following_url":
      "https://api.github.com/users/aaronlippold/following{/other_user}",
     "gists_url": "https://api.github.com/users/aaronlippold/gists{/gist_id}",
     "starred_url":
      "https://api.github.com/users/aaronlippold/starred{/owner}{/repo}",
     "subscriptions_url":
      "https://api.github.com/users/aaronlippold/subscriptions",
     "organizations_url": "https://api.github.com/users/aaronlippold/orgs",
     "repos_url": "https://api.github.com/users/aaronlippold/repos",
     "events_url": "https://api.github.com/users/aaronlippold/events{/privacy}",
     "received_events_url":
      "https://api.github.com/users/aaronlippold/received_events",
     "type": "User",
     "site_admin": false},
   "private": false,
   "html_url": "https://github.com/aaronlippold/nginx-baseline",
   "description": "DevSec Nginx Baseline - InSpec Profile",
   "fork": true,
   "url": "https://api.github.com/repos/aaronlippold/nginx-baseline",
   "forks_url": "https://api.github.com/repos/aaronlippold/nginx-baseline/forks",
   "keys_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/keys{/key_id}",
   "collaborators_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/collaborators{/collaborator}",
   "teams_url": "https://api.github.com/repos/aaronlippold/nginx-baseline/teams",
   "hooks_url": "https://api.github.com/repos/aaronlippold/nginx-baseline/hooks",
   "issue_events_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/issues/events{/number}",
   "events_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/events",
   "assignees_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/assignees{/user}",
   "branches_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/branches{/branch}",
   "tags_url": "https://api.github.com/repos/aaronlippold/nginx-baseline/tags",
   "blobs_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/git/blobs{/sha}",
   "git_tags_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/git/tags{/sha}",
   "git_refs_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/git/refs{/sha}",
   "trees_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/git/trees{/sha}",
   "statuses_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/statuses/{sha}",
   "languages_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/languages",
   "stargazers_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/stargazers",
   "contributors_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/contributors",
   "subscribers_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/subscribers",
   "subscription_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/subscription",
   "commits_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/commits{/sha}",
   "git_commits_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/git/commits{/sha}",
   "comments_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/comments{/number}",
   "issue_comment_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/issues/comments{/number}",
   "contents_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/contents/{+path}",
   "compare_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/compare/{base}...{head}",
   "merges_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/merges",
   "archive_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/{archive_format}{/ref}",
   "downloads_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/downloads",
   "issues_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/issues{/number}",
   "pulls_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/pulls{/number}",
   "milestones_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/milestones{/number}",
   "notifications_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/notifications{?since,all,participating}",
   "labels_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/labels{/name}",
   "releases_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/releases{/id}",
   "deployments_url":
    "https://api.github.com/repos/aaronlippold/nginx-baseline/deployments",
   "git_url": "git://github.com/aaronlippold/nginx-baseline.git",
   "ssh_url": "git@github.com:aaronlippold/nginx-baseline.git",
   "clone_url": "https://github.com/aaronlippold/nginx-baseline.git",
   "svn_url": "https://github.com/aaronlippold/nginx-baseline",
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
