# Establish Token for subsequent requests during this run
# No arguments needed

require 'base64'
require 'json'
require 'faraday'
require 'base64'

def get_token(server)
  rh = Creds[server]
  sv = rh['servers']
  un = rh['username']
  pw = rh['password']
  return un, pw, sv
end
