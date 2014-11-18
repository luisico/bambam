# Be sure to restart your server when you modify this file.

Bambam::Application.config.session_store :cookie_store, key: ENV['SESSION_STORE_KEY'] + "_session"
