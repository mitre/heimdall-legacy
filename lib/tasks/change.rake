namespace :change do

  desc 'bump patch version and generate changelog'
  task :patch => :environment do |task|
    # some code
    Rake::Task['version:bump:patch'].invoke
    version = File.read('VERSION')
    task_str = "github_changelog_generator mitre/heimdall --future-release=\"#{version}\""
    sh task_str
  end
end
