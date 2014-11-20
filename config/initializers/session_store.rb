# Be sure to restart your server when you modify this file.
_fullapp = "_#{Rails.root.to_s.split(File::SEPARATOR).values_at(2,4).join("_")}"

Bambam::Application.config.session_store :cookie_store, key: _fullapp + "_session"
