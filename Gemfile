source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'mongoid', '~> 6.2.0'
gem 'mongoid-simple-userstamps'
gem 'devise'
gem "rolify"
gem 'cancancan', '~> 2.0'

gem "octokit", "~> 4.0"
gem 'gitlab'

gem 'pdfkit'
gem 'render_anywhere'
gem 'wkhtmltopdf-binary'

# For inspec2ckl
gem 'nokogiri-happymapper'
gem 'happymapper'
gem 'nokogiri', '~> 1.8.1'
gem 'thor'
gem 'json'
gem 'pry'

gem 'inspec_to', :git => "https://gitlab.mitre.org/inspec/inspec_to.git"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.1'
  gem 'simplecov'
  gem 'brakeman'
  gem 'rubocop', require: false
  gem 'rails_best_practices'
end

group :test do
  gem 'capybara', '~> 2.14'
  gem 'mongoid-rspec', git: 'https://github.com/mongoid-rspec/mongoid-rspec.git'
  gem 'email_spec', '~> 2.1'
  gem 'rails-controller-testing'
  gem 'webmock'
  gem 'mocha'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
