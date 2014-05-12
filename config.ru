# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
appurl = ENV['RAILS_RELATIVE_URL_ROOT'] || '/'
map appurl do
  run Rails.application
end
