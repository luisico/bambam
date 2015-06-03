namespace :db do
  desc "Load seed data from db/populate.rb"
  task :populate => :environment do
    populate_file = Rails.root.join( 'db', 'populate.rb')
    load(populate_file) if File.exist?(populate_file)
  end
end
