require "belvo/http"
require "belvo/exceptions"

module Belvo
  class Client
    def initialize(secret_key_id, secret_key_password, url = nil)
      belvo_api_url = url or ENV["BELVO_API_URL"]
      if belvo_api_url.nil?
        raise BelvoAPIError.new "You need to provide a URL."
      end

      @session = Belvo::APISession.new belvo_api_url

      unless @session.login(secret_key_id, secret_key_password)
        raise BelvoAPIError.new "Login failed."
      end
    end
  end
end
