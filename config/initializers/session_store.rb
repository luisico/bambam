# Be sure to restart your server when you modify this file.
fullapp = ""
[2,4].each {|i| fullapp << "_#{Rails.root.to_s.split(File::SEPARATOR)[i]}"}

Bambam::Application.config.session_store :cookie_store, key: fullapp + "_session"
