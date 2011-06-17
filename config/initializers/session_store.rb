# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_RockAndGol_session',
  :secret      => '6e41ee8fedd3b071b41f72d94046cb68639729691a2c1993f568e49ac8c3024af8b4302345862836375669f26ff53d00de94d24d9a9ed0c9098f3c2630801a1e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
