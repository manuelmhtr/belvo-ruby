# frozen_string_literal: true

require 'date'
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

  # Contains the configurable properties for an Account
  class AccountOptions < Faraday::Options.new(
    :save_data,
    :token,
    :encryption_key
  )
  end

  # An Account is the representation of a bank account inside a financial
  # institution.
  class Account < Resource
    def initialize(session)
      super(session)
      @endpoint = 'accounts/'
    end

    def create(link:, options: nil)
      options = AccountOptions.from(options)
      body = {
        link: link,
        token: options.token,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties for a Transaction
  class TransactionOptions < Faraday::Options.new(
    :date_to,
    :account,
    :token,
    :encryption_key,
    :save_data
  )
  end

  # A Transaction contains the detailed information of each movement inside an
  # Account.
  class Transaction < Resource
    def initialize(session)
      super(session)
      @endpoint = 'transactions/'
    end

    def create(link:, date_from:, options: nil)
      options = TransactionOptions.from(options)
      date_to = options.date_to || Date.today.to_s
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        token: options.token,
        account: options.account,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties of an Owner
  class OwnerOptions < Faraday::Options.new(:token, :encryption_key, :save_data)
  end

  # An Owner represents the person who has access to a Link and is the owner
  # of all the Accounts inside the Link
  class Owner < Resource
    def initialize(session)
      super(session)
      @endpoint = 'owners/'
    end

    def create(link:, options: nil)
      options = OwnerOptions.from(options)
      body = {
        link: link,
        token: options.token,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties of a Balance
  class BalanceOptions < Faraday::Options.new(
    :token,
    :date_to,
    :account,
    :encryption_key,
    :save_data
  )
  end

  # A Balance represents the financial status of an Account at a given time.
  class Balance < Resource
    def initialize(session)
      super(session)
      @endpoint = 'balances/'
    end

    def create(link:, date_from:, options: nil)
      options = BalanceOptions.from(options)
      date_to = options.date_to || Date.today.to_s
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        token: options.token,
        account: options.account,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties of a Statement
  class StatementOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end

  # A Statement contains a resume of monthly Transactions inside an Account.
  class Statement < Resource
    def initialize(session)
      super(session)
      @endpoint = 'statements/'
    end

    def create(link:, account:, year:, month:, options: nil)
      options = StatementOptions.from(options)
      body = {
        link: link,
        account: account,
        year: year,
        month: month,
        token: options.token,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true,
        attach_pdf: options.attach_pdf
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties of an Invoice
  class InvoiceOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_xml
  )
  end

  # An Invoice is the representation of an electronic invoice, that can be
  # received or sent, by a business or an individual and has been uploaded
  # to the fiscal institution website
  class Invoice < Resource
    def initialize(session)
      super(session)
      @endpoint = 'invoices/'
    end

    def create(link:, date_from:, date_to:, type:, options: nil)
      options = InvoiceOptions.from(options)
      body = {
        link: link,
        date_from: date_from,
        date_to: date_to,
        type: type,
        token: options.token,
        encryption_key: options.encryption_key,
        save_data: options.save_data || true,
        attach_xml: options.attach_xml
      }.merge(options)
      body = clean body: body
      @session.post(@endpoint, body)
    end
  end

  # Contains configurable properties of a TaxReturn
  class TaxReturnOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end

  # A Tax return is the representation of the tax return document sent every
  # year by a person or a business to the tax authority in the country.
  class TaxReturn < Resource
    def initialize(session)
      super(session)
      @endpoint = 'tax-returns/'
    end

    def create(link:, year_from:, year_to:, options: nil)
      options = TaxReturnOptions.from(options)
      body = {
        link: link,
        year_from: year_from,
        year_to: year_to,
        token: options.token,
        encryption_key: options.encryption_key,
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
end
