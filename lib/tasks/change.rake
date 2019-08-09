namespace :change do

  desc 'bump patch version and generate changelog'
  task :patch => :environment do |task|
    # bump patch version
    Rake::Task['version:bump:patch'].invoke
    version = File.read('VERSION')
    task_str = "github_changelog_generator mitre/heimdall --future-release=\"#{version}\""
    sh task_str
  end

  desc 'bump minor version and generate changelog'
  task :minor => :environment do |task|
    # bump minor version
    Rake::Task['version:bump:minor'].invoke
    version = File.read('VERSION')
    task_str = "github_changelog_generator mitre/heimdall --future-release=\"#{version}\""
    sh task_str
  end

  desc 'bump major version and generate changelog'
  task :major => :environment do |task|
    # bump major version
    Rake::Task['version:bump:major'].invoke
    version = File.read('VERSION')
    task_str = "github_changelog_generator mitre/heimdall --future-release=\"#{version}\""
    sh task_str
  end

  desc 'set and push tag'
  task :tag => :environment do |task|
    # tag and push tag
    version = File.read('VERSION')
    task_str = "git tag v#{version}"
    sh task_str
    task_str = "git push origin v#{version}"
    sh task_str
  end
end
