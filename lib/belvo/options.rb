# frozen_string_literal: true

require 'faraday/options'

module Belvo
  # Contains the configurable properties for a Link
  class LinkOptions < Faraday::Options.new(
    :access_mode,
    :token,
    :encryption_key
  )
  end

  # Contains the configurable properties for an Account
  class AccountOptions < Faraday::Options.new(
    :save_data,
    :token,
    :encryption_key
  )
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

  # Contains configurable properties of an Owner
  class OwnerOptions < Faraday::Options.new(:token, :encryption_key, :save_data)
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

  # Contains configurable properties of a Statement
  class StatementOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end

  # Contains configurable properties of an Invoice
  class InvoiceOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_xml
  )
  end

  # Contains configurable properties of a TaxReturn
  class TaxReturnOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end
end
