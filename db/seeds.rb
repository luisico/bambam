# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Environment specific seeds
seed_file = Rails.root.join( 'db', 'seeds', "#{Rails.env}.rb")
load(seed_file) if File.exists?(seed_file)
