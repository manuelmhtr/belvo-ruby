# frozen_string_literal: true

require 'faraday/options'

module AccessMode
  SINGLE = 'single'
  RECURRENT = 'recurrent'
end

module Belvo
  # Represents a consumable REST resource from Belvo API
  class Resource
    attr_reader :endpoint

    def initialize(session)
      @session = session
    end

    def clean(body:)
      body.delete_if { |_key, value| value.nil? }
    end

    def list
      results = []
      @session.list(@endpoint) { |item| results.push item }
      results
    end

    def detail(id)
      @session.detail(@endpoint, id)
    end

    def delete(id)
      @session.delete(@endpoint, id)
    end

    def resume(session_id, token, link = nil)
      data = { session: session_id, token: token, link: link }
      @session.patch(@endpoint, data)
    end
  end

  # Contains the configurable properties for a Link
  class LinkOptions < Faraday::Options.new(
    :access_mode,
    :token,
    :encryption_key
  )
  end

  # A Link is a set of credentials associated to a end-user access
  class Link < Resource
    def initialize(session)
      super(session)
      @endpoint = 'links/'
    end

    def create(institution:, username:, password:, password2: nil, options: nil)
      options = LinkOptions.from(options)
      body = {
        institution: institution,
        username: username,
        password: password,
        password2: password2,
        token: options.token,
        encryption_key: options.encryption_key,
        access_mode: options.access_mode || AccessMode::SINGLE
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end

    def delete(id:)
      @session.delete(@endpoint, id)
    end

    def update(id:, password:, password2: nil, options: nil)
      options = LinkOptions.from(options)
      body = {
        password: password,
        password2: password2,
        token: options.token,
        encryption_key: options.encryption_key
      }.merge(options)
      body = clean body: body
      @session.put(@endpoint, id, body)
    end
  end
end
