# frozen_string_literal: true

module Belvo
  # Belvo API base error
  class BelvoAPIError < StandardError
    # @param message [String] Error short description
    def initialize(message)
      super(message)
    end
  end

  # Generic request error, any response with status different than 2xx.
  class RequestError < BelvoAPIError
    # HTTP code returned by Belvo API
    # @return [Integer]
    attr_reader :status_code

    # Error message returned by Belvo API
    # @return [JSON]
    attr_reader :detail

    # @param message [String] Error short description
    # @param status_code [Integer] HTTP code
    # @param detail [JSON] Detailed error(s) description
    def initialize(message, status_code, detail)
      super(message)
      @status_code = status_code
      @detail = detail
    end
  end
end
