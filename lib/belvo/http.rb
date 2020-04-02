require "faraday"
require "faraday_middleware"
require "typhoeus"
require "typhoeus/adapters/faraday"

require "belvo/version"
require "belvo/exceptions"

module Belvo
  class APISession
    def initialize(url)
      @url = "%s/api/" % [url]
      @session = Faraday::Connection.new(url: @url) do |faraday|
        faraday.adapter :typhoeus
        faraday.response :json
        faraday.headers = {
            "Content-Type" => "application/json",
            "User-Agent" => "belvo-ruby (%s)" % [Belvo::VERSION]
        }
      end
    end

    private

    def key_id=(secret_key_id)
      @key_id = secret_key_id
    end

    def key_password=(secret_key_password)
      @key_password = secret_key_password
    end

    def raise_for_status(response)
      unless response.success?
        raise RequestError.new(
            "Request error",
            response.status,
            response.body.to_s
        )
      end
      response
    end

    def authenticate
      @session.basic_auth(@key_id, @key_password)

      response = @session.get("") do |req|
        req.options
      end
      raise_for_status response

      true
    end

    def get(path, params=nil)
      if params.nil?
        params = {}
      end

      response = @session.get(path, params)

      raise_for_status response
    end

    public

    def login(secret_key_id, secret_key_password)
      @key_id = secret_key_id
      @key_password = secret_key_password

      authenticate
    end

    def list(path, params=nil)
      if params.nil?
        params = {}
      end

      while true
        response = get(path, params)
        results = response.body["results"]
        results.each do |item|
          yield item
        end

        if response.body["next"]
          path = response.body["next"]
          params = nil
        else
          break
        end
      end
    end

    def detail(path, id, params=nil)
      if params.nil?
        params = {}
      end

      resource_path = "%s%s/" % [path, id]
      response = get(resource_path, params)

      raise_for_status response
      response.body
    end

    def post(path, data)
      response = @session.post(path, body=data)
      raise_for_status response
      response.body
    end

    def patch(path, data)
      response = @session.patch(path, body=data)
      raise_for_status response
      response.body
    end

    def delete(path, id)
      resource_url = "%s%s/" % [path, id]
      response = @session.delete(resource_url)
      response.success?
    end
  end
end
