# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cbn_session',
  :secret      => 'dc1ae55ba13026d2defa26837cb3348015999a3c25e1514fc89c4c3060f0c0863db9425cec9806f1cf329ef20d813e209d7c38c1158781a3c2994a9b48792294'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
