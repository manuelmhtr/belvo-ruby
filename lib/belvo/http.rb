# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'belvo/version'
require 'belvo/exceptions'

module Belvo
  # Describes a Belvo API session
  class APISession
    attr_reader :key_id
    attr_reader :key_password

    # @param url [String] Belvo API host url
    # @return [Faraday::Connection]
    def initialize(url)
      @url = format('%<url>s/', url: url)
      @session = Faraday::Connection.new(url: @url) do |faraday|
        faraday.adapter :typhoeus
        faraday.response :json
        faraday.headers = {
          'Content-Type' => 'application/json',
          'User-Agent' => format(
            'belvo-ruby (%<version>s)',
            version: Belvo::VERSION
          )
        }
      end
    end

    private

    # Raise an error if the response code is not 2XX.
    # @param response [Faraday::Response]
    # @return [Faraday::Response]
    def raise_for_status(response)
      unless response.success?
        raise RequestError.new(
          'Request error',
          response.status,
          response.body.to_s
        )
      end
      response
    end

    # Set and validate authentication credentials
    # @return [Boolean] True if credentials are valid to authenticate
    #   to Belvo API else False.
    def authenticate
      @session.basic_auth(@key_id, @key_password)
      response = @session.get('')
      response.success?
    end

    # Perform GET request to a Belvo API endpoint. Needed for Detail and List.
    # @param path [String] API Endpoint
    # @param params [Hash] Params to be send as querystring
    # @return [Faraday::Response]
    # @raise [RequestError] If response code is different than 2XX
    def get(path, params: nil)
      params = {} if params.nil?
      response = @session.get(path) do |req|
        req.params = params
      end
      raise_for_status response
    end

    public

    # Authenticate to Belvo API using the given credentials.
    # @param secret_key_id [String]
    # @param secret_key_password [String]
    # @return [Boolean] True if credentials are valid to authenticate
    #   to Belvo API else False.
    def login(secret_key_id, secret_key_password)
      @key_id = secret_key_id
      @key_password = secret_key_password

      authenticate
    end

    # List results from an API endpoint. It will yield all results following
    # pagination's next page, if any.
    # @param path [String] API endpoint
    # @param params [Hash] Params to be send as querystring
    # @yield [Hash] Each result
    # @raise [RequestError] If response code is different than 2XX
    def list(path, params: nil)
      params = {} if params.nil?
      loop do
        response = get(path, params: params)
        response.body['results'].each do |item|
          yield item if block_given?
        end

        break unless response.body['next']

        params = Faraday::Utils.parse_query URI(response.body['next']).query
      end
    end

    # Show specific resource details
    # @param path [String] API endpoint
    # @param id [String] Resource UUID
    # @param params [Hash] Params to be send as querystring
    # @return [Hash] Resource details
    # @raise [RequestError] If response code is different than 2XX
    def detail(path, id, params: nil)
      params = {} if params.nil?

      resource_path = format('%<path>s%<id>s/', path: path, id: id)
      response = get(resource_path, params)

      raise_for_status response
      response.body
    end

    # Perform a POST request to an API endpoint
    # @param path [String] API endpoint
    # @param id [String] Resource UUID
    # @param data [object] JSON parseable object
    # @return [Hash] Response details
    # @raise [RequestError] If response code is different than 2XX
    def token(path, id, data)
      resource_path = format('%<path>s%<id>s/token/', path: path, id: id)
      response = @session.post(resource_path, data.to_json)
      raise_for_status response
      response.body
    end

    # Perform a POST request to an API endpoint
    # @param path [String] API endpoint
    # @param data [object] JSON parseable object
    # @return [Hash] Response details
    # @raise [RequestError] If response code is different than 2XX
    def post(path, data)
      response = @session.post(path, data.to_json)
      raise_for_status response
      response.body
    end

    # Perform a PUT request to an specific resource
    # @param path [String] API endpoint
    # @param id [String] Resource UUID
    # @param data [object] JSON parseable object
    # @return [Hash] Response details
    # @raise [RequestError] If response code is different than 2XX
    def put(path, id, data)
      url = format('%<path>s%<id>s/', path: path, id: id)
      response = @session.put(url, data.to_json)
      raise_for_status response
      response.body
    end

    # Perform a PATCH request to an API endpoint
    # @param path [String] API endpoint
    # @param data [object] JSON parseable object
    # @return [Hash] Response details
    # @raise [RequestError] If response code is different than 2XX
    def patch(path, data)
      response = @session.patch(path, data.to_json)
      raise_for_status response
      response.body
    end

    # Delete existing resource
    # @param path [String] API endpoint
    # @param id [String] Resource UUID
    # @return [Boolean] true if resource is successfully deleted else false
    def delete(path, id)
      resource_path = format('%<path>s%<id>s/', path: path, id: id)
      response = @session.delete(resource_path)
      response.success?
    end
  end
end
