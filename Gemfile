source 'https://rubygems.org'

ruby '2.2.0'

# Monitoring
gem 'newrelic_rpm', '~> 3.12.0'
gem 'health_check', '~> 1.5.1'
gem 'exception_notification', '~> 4.1.0'

gem 'rails', '~> 4.1.11'

# Env variables (must be at top)
gem 'dotenv-rails', '~> 2.0.1', group: [:development, :test]

# Database
gem 'pg', '~> 0.18.2'
gem 'ransack', '~> 1.6.6'

# Factories
gem 'factory_girl_rails', '~> 4.5.0'

# Authentication / Authorization
gem 'devise', '3.5.1'
gem 'devise_invitable', '1.4.2'
gem 'cancancan', '~> 1.10.1'
gem 'rolify', '~> 4.0.0'

# Assets
gem 'sass-rails', '~> 4.0.5'
gem 'uglifier', '~> 2.7.1'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails', '~> 3.1.3'
gem 'jquery-ui-sass-rails', github: 'jhilden/jquery-ui-sass-rails'
gem 'turbolinks', '~> 2.5.3 '
gem 'foundation-rails', '~> 5.2.3.0'
gem 'local_time', '~> 1.0.2'
gem 'foundation-icons-sass-rails'
gem 'best_in_place', '~> 3.0.3'

# JSON APIs
gem 'jbuilder', '~> 2.2.16'

group :development do
  gem 'spring', '~> 1.3.6'
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'spring-commands-cucumber', '~> 1.0.1'
  gem 'pry-rails', '~> 0.3.4'
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.1'
  gem 'guard-rspec', '~> 4.5.1'
  gem 'guard-cucumber', '~> 1.5.4'
  gem 'rb-inotify', '~> 0.9.5', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'quiet_assets', '~> 1.1.0'
end

group :test do
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.6.0'
  gem 'selenium-webdriver', '~> 2.40.0'
  gem 'launchy', '~> 2.4.3'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'email_spec', '~> 1.6.0'
end

group :production, :staging do
  gem 'therubyracer', platforms: :ruby
  gem 'nokogiri', '~> 1.6.1'
  gem 'puma', '~> 2.9.2'
  gem 'lograge', '~> 0.3.3'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1', group: :doc

# Gems to install outside the Gemfile
# foreman
# mailcatcher
