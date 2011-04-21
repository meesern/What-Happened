# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_WhatHappened_session',
  :secret      => '6d6a81f86ba9888a3ef18d85836a60146cbd96bf2e9188deb6462ce641af00512c05856a8416ffef30ee5ea9566a9c81664134bfc20d0d7c3c6afda440a5fe46'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
