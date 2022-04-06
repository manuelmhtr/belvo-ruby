# frozen_string_literal: true

require 'date'
require 'belvo/options'
require 'belvo/utils'

module Belvo
  # Represents a consumable REST resource from Belvo API
  class Resource
    # Resource API endpoint
    # @return [String] the API endpoint
    attr_reader :endpoint

    # @param session [APISession] current Belvo API session
    def initialize(session)
      @session = session
    end

    # Remove nil values from a request body
    # @param body [Hash] request body
    # @return [Hash] body without nil values
    def clean(body:)
      body.delete_if { |_key, value| value.nil? }
    end

    # List all results
    # @param params [Hash] Extra parameters sent as query strings.
    # @return [Array] List of results when no block is passed.
    # @yield [Hash] Each result to be processed individually.
    # @raise [RequestError] If response code is different than 2XX
    def list(params: nil)
      results = block_given? ? nil : []
      @session.list(@endpoint, params: params) do |item|
        results.nil? ? yield(item) : results.push(item)
      end
      results
    end

    # Show specific resource details
    # @param id [String] Resource UUID
    # @return [Hash]
    # @raise [RequestError] If response code is different than 2XX
    def detail(id:)
      @session.detail(@endpoint, id)
    end

    # Delete existing resource
    # @param id [String] Resource UUID
    # @return [Boolean] true if resource is successfully deleted else false
    def delete(id:)
      @session.delete(@endpoint, id)
    end

    # Resume data extraction session. Use this method after you have received a
    #   HTTP 428 response.
    # @param session_id [String] Session UUID included in the 428 response
    # @param link [String, nil] Link UUID
    # @raise [RequestError] If response code is different than 2XX
    def resume(session_id:, token:, link: nil)
      data = { session: session_id, token: token, link: link }
      @session.patch(@endpoint, data)
    end
  end

  # A Link is a set of credentials associated to a end-user access
  class Link < Resource
    class AccessMode
      # Use single to do ad hoc one-time requests
      SINGLE = 'single'
      # Use recurrent to have Belvo refresh your link data on a daily basis
      RECURRENT = 'recurrent'
    end

    def initialize(session)
      super(session)
      @endpoint = 'api/links/'
    end

    # Register a new link
    # @param institution [String] Institution name
    # @param username [String] End-user username
    # @param password [String] End-user password
    # @param options [LinkOptions] Configurable properties
    # @return [Hash] created link details
    # @raise [RequestError] If response code is different than 2XX
    def register(
      institution:,
      username:,
      password:,
      options: nil
    )
      options = LinkOptions.from(options)
      options.certificate = Utils.read_file_to_b64(options.certificate)
      options.private_key = Utils.read_file_to_b64(options.private_key)
      body = {
        institution: institution,
        username: username,
        password: password,
        access_mode: options.access_mode
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end

    # Allows to change password, password2
    # @param id [String] Link UUID
    # @param password [String] End-user password
    # @param password2 [String, nil] End-user secondary password, if any
    # @param options [LinkOptions] Configurable properties
    # @return [Hash] link details
    # @raise [RequestError] If response code is different than 2XX
    def update(id:, password: nil, password2: nil, options: nil)
      options = LinkOptions.from(options)
      options.certificate = Utils.read_file_to_b64(options.certificate)
      options.private_key = Utils.read_file_to_b64(options.private_key)
      body = {
        password: password,
        password2: password2,
        token: options.token,
        username_type: options.username_type,
        certificate: options.certificate,
        private_key: options.private_key
      }.merge(options)
      body = clean body: body
      @session.put(@endpoint, id, body)
    end

    # Allows to create a token with client-specified scope and short TTL.
    # @param id [String] Link UUID
    # @param scopes [String] Configurable scopes eg: "read_links,write_links"
    # @return [Hash] with a "refresh" and "access" token
    # @raise [RequestError] If response code is different than 2XX
    def token(id:, scopes:)
      body = {
        scopes: scopes
      }
      @session.token(@endpoint, id, body)
    end

    # Patch an existing link
    # @param id [String] Link UUID
    # @param options [LinkOptions] Configurable properties
    # @return [Hash] created link details
    # @raise [RequestError] If response code is different than 2XX
    def patch(
      id:,
      options: nil
    )
      options = LinkOptions.from(options)
      body = {
        access_mode: options.access_mode
      }.merge(options)
      body = clean body: body
      resource_path = format('%<path>s%<id>s/', path: @endpoint, id: id)
      @session.patch(resource_path, body)
    end
  end

  # An Account is the representation of a bank account inside a financial
  # institution.
  class Account < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/accounts/'
    end

    # Retrieve accounts from an existing link
    # @param link [String] Link UUID
    # @param options [AccountOptions] Configurable properties
    # @return [Hash] created accounts details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = AccountOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A Transaction contains the detailed information of each movement inside an
  # Account.
  class Transaction < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/transactions/'
    end

    # Retrieve transactions from an existing link
    # @param link [String] Link UUID
    # @param date_from [String] Date string (YYYY-MM-DD)
    # @param options [TransactionOptions] Configurable properties
    # @return [Hash] created transactions details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, date_from:, options: nil)
      options = TransactionOptions.from(options)
      date_to = options.date_to || Date.today.to_s
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        token: options.token,
        account: options.account,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # An Owner represents the person who has access to a Link and is the owner
  # of all the Accounts inside the Link
  class Owner < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/owners/'
    end

    # Retrieve owners from an existing link
    # @param link [String] Link UUID
    # @param options [OwnerOptions] Configurable properties
    # @return [Hash] created owners details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = OwnerOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A Balance represents the financial status of an Account at a given time.
  class Balance < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/balances/'
    end

    # Retrieve balances from a specific account or all accounts from a
    #   specific link
    # @param link [String] Link UUID
    # @param date_from [String] Date string (YYYY-MM-DD)
    # @param options [BalanceOptions] Configurable properties
    # @return [Hash] created balances details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, date_from:, options: nil)
      options = BalanceOptions.from(options)
      date_to = options.date_to || Date.today.to_s
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        token: options.token,
        account: options.account,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A Statement contains a resume of monthly Transactions inside an Account.
  class Statement < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/statements/'
    end

    # Retrieve statements information from a specific banking link.
    # @param link [String] Link UUID
    # @param year [Integer]
    # @param month [Integer]
    # @param options [StatementOptions] Configurable properties
    # @return [Hash] created statement details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, account:, year:, month:, options: nil)
      options = StatementOptions.from(options)
      body = {
        link: link,
        account: account,
        year: year,
        month: month,
        token: options.token,
        save_data: options.save_data || true,
        attach_pdf: options.attach_pdf
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A Income contains a resume of monthly Transactions inside an Account.
  class Income < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/incomes/'
    end

    # Retrieve incomes information from a specific banking link.
    # @param link [String] Link UUID
    # @param options [IncomesOptions] Configurable properties
    # @return [Hash] created incomes details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = IncomeOptions.from(options)
      body = {
        link: link,
        save_data: options.save_data || true,
        date_from: options.date_from,
        date_to: options.date_to
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # An Invoice is the representation of an electronic invoice, that can be
  # received or sent, by a business or an individual and has been uploaded
  # to the fiscal institution website
  class Invoice < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/invoices/'
    end

    # @param link [String] Link UUID
    # @param date_from [String] Date string (YYYY-MM-DD)
    # @param date_to [String] Date string (YYYY-MM-DD)
    # @param options [InvoiceOptions] Configurable properties
    # @return [Hash] created invoices details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, date_from:, date_to:, type:, options: nil)
      options = InvoiceOptions.from(options)
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        type: type,
        token: options.token,
        save_data: options.save_data || true,
        attach_xml: options.attach_xml
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Recurring Expenses contain a resume of one year
  # of Transactions inside an Account.
  class RecurringExpenses < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/recurring-expenses/'
    end

    # Retrieve recurring expenses information from a specific banking link
    # @param link [String] Link UUID
    # @param options [RecurringExpensesOptions] Configurable properties
    # @return [Hash] created RecurringExpenses details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = RecurringExpensesOptions.from(options)
      body = {
        link: link,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # RiskInsights contain relevant metrics about
  # the credit risk of a Link
  class RiskInsights < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/risk-insights/'
    end

    # Retrieve risk insights information from a specific banking link
    # @param link [String] Link UUID
    # @param options [RiskInsightsOptions] Configurable properties
    # @return [Hash] created RiskInsights details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = RiskInsightsOptions.from(options)
      body = {
        link: link,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A Tax compliance status is the representation of the tax situation
  # of a person or a business to the tax authority in the country.
  class TaxComplianceStatus < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/tax-compliance-status/'
    end

    # Retrieve tax compliance status information from a specific fiscal link.
    # @param link [String] Link UUID
    # @param options [TaxComplianceStatusOptions] Configurable properties
    # @return [Hash] created tax compliance status details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = TaxComplianceStatusOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true,
        attach_pdf: options.attach_pdf
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end

    def resume(_session_id, _token, _link: nil)
      raise NotImplementedError 'TaxComplianceStatus does not support'\
            ' resuming a session'
    end
  end

  # A Tax return is the representation of the tax return document sent every
  # year by a person or a business to the tax authority in the country.
  class TaxReturn < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/tax-returns/'
    end

    class TaxReturnType
      YEARLY = 'yearly'
      MONTHLY = 'monthly'
    end

    # Retrieve tax returns information from a specific fiscal link.
    # @param link [String] Link UUID
    # @param year_from [Integer]
    # @param year_to [Integer]
    # @param options [TaxReturnOptions] Configurable properties
    # @return [Hash] created tax returns details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, year_from: nil, year_to: nil, options: nil)
      options = TaxReturnOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true,
        attach_pdf: options.attach_pdf,
        type: options.type
      }.merge(options)
      if options.type == TaxReturnType::MONTHLY
        body[:date_from] = options.date_from
        body[:date_to] = options.date_to
      else
        body[:year_from] = year_from
        body[:year_to] = year_to
      end
      body = clean body: body
      @session.post(@endpoint, body)
    end

    def resume(_session_id, _token, _link: nil)
      raise NotImplementedError 'TaxReturn does not support resuming a session.'
    end
  end

  # A Tax status is the representation of the tax situation of a person or a
  # business to the tax authority in the country.
  class TaxStatus < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/tax-status/'
    end

    # Retrieve tax status information from a specific fiscal link.
    # @param link [String] Link UUID
    # @param options [TaxStatusOptions] Configurable properties
    # @return [Hash] created tax status details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = TaxStatusOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true,
        attach_pdf: options.attach_pdf
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end

    def resume(_session_id, _token, _link: nil)
      raise NotImplementedError 'TaxReturn does not support resuming a session.'
    end
  end

  # An Institution is an entity that Belvo can access information from. It can
  # be a bank or fiscal type of institutions such as the SAT in Mexico.
  class Institution < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/institutions/'
    end
  end

  # A WidgetToken is a limited scope with short time to live token, that
  # contains access and refresh keys to allow you embedding Belvo's Connect
  # Widget into your app.
  class WidgetToken < Resource
    def initialize(session)
      super(session)
      @endpoint = 'api/token/'
    end

    def create(options: nil)
      options = WidgetTokenOptions.from(options)
      link_id = options.link
      widget = options.widget
      options.delete('link')
      options.delete('widget')
      body = {
        id: @session.key_id,
        password: @session.key_password,
        scopes: 'read_institutions,write_links,read_links',
        link_id: link_id,
        widget: widget
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A InvestmentsPortfolio is a comprehensive view of your user's current
  # investment holdings
  class InvestmentsPortfolio < Resource
    def initialize(session)
      super(session)
      @endpoint = 'investments/portfolios/'
    end

    # Retrieve investments portfolios from an existing link
    # @param link [String] Link UUID
    # @param options [InvestmentsPortfolioOptions] Configurable properties
    # @return [Hash] created investments portfolios details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, options: nil)
      options = InvestmentsPortfolioOptions.from(options)
      body = {
        link: link,
        token: options.token,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # A InvestmentsTransaction gets the existing transactions for an instrument
  class InvestmentsTransaction < Resource
    def initialize(session)
      super(session)
      @endpoint = 'investments/transactions/'
    end

    # Retrieve investments transactions from an existing link
    # @param link [String] Link UUID
    # @param date_from [String] Date string (YYYY-MM-DD)
    # @param options [InvestmentsTransactionOptions] Configurable properties
    # @return [Hash] created investments transactions details
    # @raise [RequestError] If response code is different than 2XX
    def retrieve(link:, date_from:, options: nil)
      options = InvestmentsTransactionOptions.from(options)
      date_to = options.date_to || Date.today.to_s
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        token: options.token,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end
end
