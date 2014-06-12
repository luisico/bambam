source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.5'

# Env variables (must be at top)
gem 'dotenv-rails', '~> 0.10.0', group: [:development, :test]

# Database
gem 'sqlite3', '~> 1.3.9', group: [:development, :test]
gem 'pg', '~> 0.17.1', group: [:production, :staging]

# Factories
gem 'factory_girl_rails', '~> 4.4.0'

# Authentication / Authorization
gem 'devise', '~> 3.2.3'
gem 'devise_invitable', github: 'scambra/devise_invitable'
gem 'rolify', '~> 3.4.0'
gem 'cancancan', '~> 1.7'

# Assets
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '~> 2.5.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails', '~> 3.1.0'
gem 'turbolinks', '~> 2.2.1 '
gem 'foundation-rails', '~> 5.2.2'
gem 'local_time'
gem 'foundation-icons-sass-rails'

# JSON APIs
gem 'jbuilder', '~> 1.5.2'

group :development do
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.1'
  gem 'guard-rspec', '~> 4.2.7'
  gem 'guard-cucumber', '~> 1.4.1'
  gem 'rb-inotify', '~> 0.9.3', require: false
  gem 'spring', '~> 1.1.1'
  gem 'spring-commands-rspec', '~> 1.0.1'
  gem 'spring-commands-cucumber', '~> 1.0.1'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem 'cucumber-rails', '~> 1.4.0', require: false
  gem 'capybara', '~> 2.2.1'
  gem 'poltergeist', '~> 1.5.0'
  gem 'selenium-webdriver', '~> 2.40.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'email_spec', '~> 1.5.0'
  gem 'launchy', '~> 2.4.2'
end

group :development, :test do
  gem 'pry-rails', '~> 0.3.2'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'shoulda-matchers', '~> 2.4.0'
  gem 'quiet_assets', '~> 1.0.2'
  gem 'mailcatcher', github: 'sj26/mailcatcher', ref:  '272b4fa855'
  gem 'foreman', '~> 0.63.0'
end

group :production, :staging do
  gem 'therubyracer', platforms: :ruby
  gem 'nokogiri', '~> 1.6.1'
  gem 'puma', '~> 2.8.2'
end

gem 'exception_notification', '~> 4.0.1'
