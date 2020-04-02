# frozen_string_literal: true

require 'belvo/http'
require 'belvo/exceptions'

module Belvo
  # Belvo API HTTP client
  class Client
    def initialize(secret_key_id, secret_key_password, url = nil)
      (belvo_api_url = url) || ENV['BELVO_API_URL']
      raise BelvoAPIError, 'You need to provide a URL.' if belvo_api_url.nil?

      @session = Belvo::APISession.new belvo_api_url

      return if @session.login(secret_key_id, secret_key_password)

      raise BelvoAPIError, 'Login failed.'
    end
  end
end
