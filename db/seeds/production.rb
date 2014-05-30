# Admin and users
FactoryGirl.create(:admin, email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD'])
FactoryGirl.create(:user, email: ENV['UCSC_USER_EMAIL'], password: ENV['UCSC_USER_PASSWORD'], password_confirmation: ENV['UCSC_USER_PASSWORD'])
