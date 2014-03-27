# Use seed data from the development environment
populate_file = Rails.root.join( 'db', 'seeds', 'development.rb')
load(populate_file) if !Rails.env.development? && File.exists?(populate_file)
