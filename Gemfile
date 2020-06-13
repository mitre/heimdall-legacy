source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'omniauth', '~>1.8'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

gem 'gibberish'
gem 'devise', '>= 4.7.1'
gem 'devise_ldap_authenticatable'
gem "rolify"
gem 'cancancan', '~> 2.0'
gem 'pdfkit'
gem 'render_anywhere'
gem 'wkhtmltopdf-binary', '0.12.3.1'
gem 'rmagick'
gem 'carrierwave'
gem 'nokogiri-happymapper'
gem "nokogiri", ">= 1.10.4"
gem 'thor'
gem 'json'
gem 'fuzzy-string-match'
gem 'inspec_tools', '>= 1.4.2'
gem 'roo'
gem "rake-version", "~> 1.0"
gem 'versionator'
gem 'data_migrate'

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.6'
  gem 'rubocop-rspec'
  gem 'factory_bot_rails'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.1'
  gem 'simplecov'
  gem 'brakeman'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rails_best_practices'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'github_changelog_generator'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'email_spec', '~> 2.1'
  gem 'rails-controller-testing'
  gem 'webmock'
  gem 'mocha'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
