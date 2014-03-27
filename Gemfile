source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.4'

# Env variables (must be at top)
gem 'dotenv-rails', '~> 0.10.0', group: [:development, :test]

# Database
gem 'sqlite3', '~> 1.3.9', group: [:development, :test]
gem 'pg', '~> 0.17.1', group: [:production]

# Factories
gem 'factory_girl_rails', '~> 4.4.0'

# Launcher
gem 'foreman', '~> 0.63.0'

# Assets
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails'
gem 'turbolinks'

# JSON APIs
gem 'jbuilder', '~> 1.5.2'

group :development do
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.1'
  gem 'guard-rspec', '~> 4.2.7'
  gem 'guard-cucumber', '~> 1.4.1'
  gem 'rb-inotify', '~> 0.9.3', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem 'cucumber-rails', '~> 1.4.0', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'capybara', '~> 2.2.1'
  gem 'email_spec', '~> 1.5.0'
  gem 'poltergeist', '~> 1.5.0'
  gem 'launchy', '~> 2.4.2'
end

group :development, :test do
  gem 'pry-rails', '~> 0.3.2'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'shoulda-matchers', '~> 2.4.0'
  gem 'quiet_assets', '~> 1.0.2'
  gem 'mailcatcher', github: 'sj26/mailcatcher'
end
