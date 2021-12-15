# Usage: Update cookieEnc value and run script. 
# $ ruby rack-decode.rb

require 'base64'
require 'rack'

class Rack::Session::SessionId
end
# Insert Base64 encoded cookie data here
cookieEnc = ''
# Decode and Deserialize cookie data
cookieDec = Marshal.load(Base64.decode64(cookieEnc).chomp)

puts(cookieDec)
