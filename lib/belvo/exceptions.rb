module Belvo
  class RequestError < StandardError
    attr_reader :status_code, :detail

    def initialize(message, status_code, detail)
      super(message)
      @status_code = status_code
      @detail = detail
    end
  end
end
