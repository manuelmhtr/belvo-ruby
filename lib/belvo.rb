# frozen_string_literal: true

require 'belvo/http'
require 'belvo/exceptions'
require 'belvo/resources'

module Belvo
  # Allows easy access to Belvo API servers.
  class Client
    attr_reader :session

    def initialize(secret_key_id, secret_key_password, url = nil)
      (belvo_api_url = url) || ENV['BELVO_API_URL']
      raise BelvoAPIError, 'You need to provide a URL.' if belvo_api_url.nil?

      @session = Belvo::APISession.new(belvo_api_url)

      return if @session.login(secret_key_id, secret_key_password)

      raise BelvoAPIError, 'Login failed.'
    end

    def links
      @links = Link.new @session
    end

    def accounts
      @accounts = Account.new @session
    end

    def transactions
      @transactions = Transaction.new @session
    end

    def owners
      @owners = Owner.new @session
    end

    def balances
      @balances = Balance.new @session
    end

    def statements
      @statements = Statement.new @session
    end

    def invoices
      @invoices = Invoice.new @session
    end

    def tax_returns
      @tax_returns = TaxReturn.new @session
    end
  end
end
