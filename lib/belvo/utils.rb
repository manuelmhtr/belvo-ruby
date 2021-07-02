# frozen_string_literal: true

require 'base64'

# Class with helper functions
class Utils
  def self.read_file_to_b64(path)
    return if path.nil? || !File.file?(path)

    data = File.open(path).read
    Base64.encode64(data)
  end
end

# Class to get the api url given an environment name
class Environment
  SANDBOX = 'https://sandbox.belvo.com'
  DEVELOPMENT = 'https://development.belvo.com'
  PRODUCTION = 'https://api.belvo.com'

  def self.get_url(environment)
    nil unless environment
    begin
      const_get environment.upcase
    rescue NameError
      environment
    end
  end
end
