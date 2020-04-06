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
    def initialize(url)
      @url = format('%<url>s/api/', url: url)
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

    attr_writer :key_id

    attr_writer :key_password

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

    def authenticate
      @session.basic_auth(@key_id, @key_password)
      response = @session.get('')
      response.success?
    end

    def get(path, params = nil)
      params = {} if params.nil?
      response = @session.get(path) do |req|
        req.params = params
      end
      raise_for_status response
    end

    public

    def login(secret_key_id, secret_key_password)
      @key_id = secret_key_id
      @key_password = secret_key_password

      authenticate
    end

    def list(path, params = nil)
      params = {} if params.nil?
      loop do
        response = get(path, params: params)
        response.body['results'].each do |item|
          yield item if block_given?
        end

        break unless response.body['next']

        path = response.body['next']
        params = nil
      end
    end

    def detail(path, id, params = nil)
      params = {} if params.nil?

      resource_path = format('%<path>s%<id>s/', path: path, id: id)
      response = get(resource_path, params)

      raise_for_status response
      response.body
    end

    def post(path, data)
      response = @session.post(path, data.to_json)
      raise_for_status response
      response.body
    end

    def put(path, id, data)
      url = format('%<path>s%<id>s/', path: path, id: id)
      response = @session.put(url, data.to_json)
      raise_for_status response
      response.body
    end

    def patch(path, data)
      response = @session.patch(path, data.to_json)
      raise_for_status response
      response.body
    end

    def delete(path, id)
      resource_path = format('%<path>s%<id>s/', path: path, id: id)
      response = @session.delete(resource_path)
      response.success?
    end
  end
end
