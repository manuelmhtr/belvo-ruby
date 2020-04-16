# frozen_string_literal: true

require 'faraday/options'

module Belvo
  # @!class LinkOptions < Faraday::Options
  # Contains the configurable properties for a Link
  # @!attribute access_mode [rw] Link access mode (SINGLE or RECURRENT)
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute username_type [rw] Type of the username provided
  class LinkOptions < Faraday::Options.new(
    :access_mode,
    :token,
    :encryption_key,
    :username_type
  )
  end

  # @!class AccountOptions < Faraday::Options
  # Contains the configurable properties for an Account
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  class AccountOptions < Faraday::Options.new(
    :save_data,
    :token,
    :encryption_key
  )
  end

  # @!class TransactionOptions < Faraday::Options
  # Contains configurable properties for a Transaction
  # @!attribute date_to [rw] Date string (YYYY-MM-DD)
  # @!attribute account [rw] Account ID (UUID)
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  class TransactionOptions < Faraday::Options.new(
    :date_to,
    :account,
    :token,
    :encryption_key,
    :save_data
  )
  end

  # @!class OwnerOptions < Faraday::Options
  # Contains configurable properties of an Owner
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  class OwnerOptions < Faraday::Options.new(:token, :encryption_key, :save_data)
  end

  # @!class BalanceOptions < Faraday::Options
  # Contains configurable properties of a Balance
  # @!attribute date_to [rw] Date string (YYYY-MM-DD)
  # @!attribute account [rw] Account ID (UUID)
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  class BalanceOptions < Faraday::Options.new(
    :date_to,
    :account,
    :token,
    :encryption_key,
    :save_data
  )
  end

  # @!class StatementOptions < Faraday::Options
  # Contains configurable properties of a Statement
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute attach_pdf [rw] Should the PDF file be included in the
  #   response or not.
  class StatementOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end

  # @!class InvoiceOptions < Faraday::Options
  # Contains configurable properties of an Invoice
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute attach_xml [rw] Should the XML file be included in the
  #   response or not.
  class InvoiceOptions < Faraday::Options.new(
    :save_data,
    :token,
    :encryption_key,
    :attach_xml
  )
  end

  # @!class TaxReturnOptions < Faraday::Options
  # Contains configurable properties of a TaxReturn
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute attach_pdf [rw] Should the PDF file be included in the
  #   response or not.
  class TaxReturnOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end
end
