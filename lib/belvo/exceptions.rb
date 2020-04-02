# frozen_string_literal: true

module Belvo
  # Belvo API base error
  class BelvoAPIError < StandardError
    def initialize(message)
      super(message)
    end
  end

  # Generic request error - Any status different than 2xx
  class RequestError < BelvoAPIError
    attr_reader :status_code, :detail

    def initialize(message, status_code, detail)
      super(message)
      @status_code = status_code
      @detail = detail
    end
  end
end
