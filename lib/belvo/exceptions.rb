module Belvo
  class BelvoAPIError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class RequestError < BelvoAPIError
    attr_reader :status_code, :detail

    def initialize(message, status_code, detail)
      super(message)
      @status_code = status_code
      @detail = detail
    end
  end
end
