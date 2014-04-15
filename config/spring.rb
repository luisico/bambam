Spring.after_fork do
  # Reload locales
  I18n.reload!

  # Reload routes
  Bambam::Application.reload_routes!

  # Reload factories
  require 'factory_girl_rails'
  FactoryGirl.reload
end
