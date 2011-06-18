# Be sure to restart your server when you modify this file.

Kato::Application.config.session_store :cookie_store, :key => '_kato_session', :domain => "http://apps.facebook.com/"

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Kato::Application.config.session_store :active_record_store
