# frozen_string_literal: true

require 'belvo/http'
require 'belvo/exceptions'
require 'belvo/resources'
require 'belvo/utils'

module Belvo
  # Allows easy access to Belvo API servers.
  class Client
    # Current Belvo API session
    # @return [APISession]
    attr_reader :session

    # @param secret_key_id [String]
    # @param secret_key_password [String]
    # @param url [String, nil] API host URL, can be set from the environment
    #  using the variable name BELVO_API_URL
    # @return [APISession] Authenticated Belvo API session
    def initialize(secret_key_id, secret_key_password, url = nil)
      (belvo_api_url = url) || ENV['BELVO_API_URL']
      belvo_api_url = Environment.get_url(belvo_api_url)

      if belvo_api_url.nil?
        raise BelvoAPIError, 'You need to provide a URL or a valid environment.'
      end

      @session = Belvo::APISession.new(belvo_api_url)

      return if @session.login(secret_key_id, secret_key_password)

      raise BelvoAPIError, 'Login failed.'
    end

    # Provides access to Links resource
    # @return [Link]
    def links
      @links = Link.new @session
    end

    # Provides access to Accounts resource
    # @return [Account]
    def accounts
      @accounts = Account.new @session
    end

    # Provides access to Transactions resource
    # @return [Transaction]
    def transactions
      @transactions = Transaction.new @session
    end

    # Provides access to Owners resource
    # @return [Owner]
    def owners
      @owners = Owner.new @session
    end

    # Provides access to Balances resource
    # @return [Balance]
    def balances
      @balances = Balance.new @session
    end

    # Provides access to Statements resource
    # @return [Statement]
    def statements
      @statements = Statement.new @session
    end

    # Provides access to Incomes resource
    # @return [Income]
    def incomes
      @incomes = Income.new @session
    end

    # Provides access to Invoices resource
    # @return [Invoice]
    def invoices
      @invoices = Invoice.new @session
    end

    # Provides access to TaxComplianceStatus resource
    # @return [TaxComplianceStatus]
    def tax_compliance_status
      @tax_compliance_status = TaxComplianceStatus.new @session
    end

    # Provides access to TaxReturns resource
    # @return [TaxReturn]
    def tax_returns
      @tax_returns = TaxReturn.new @session
    end

    # Provides access to TaxStatus resource
    # @return [TaxStatus]
    def tax_status
      @tax_status = TaxStatus.new @session
    end

    # Provides access to Instituions resource
    # @return [Institution]
    def institutions
      @institutions = Institution.new @session
    end

    # Provides access to WidgetToken resource
    # @return [WidgetToken]
    def widget_token
      @widget_token = WidgetToken.new @session
    end
  end
end
