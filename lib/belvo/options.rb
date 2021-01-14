# frozen_string_literal: true

require 'faraday/options'

module Belvo
  # @!class LinkOptions < Faraday::Options
  # Contains the configurable properties for a Link
  # @!attribute access_mode [rw] Link access mode (SINGLE or RECURRENT)
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute username2 [rw] End-user secondary username, if any
  # @!attribute username3 [rw] End-user tertiary username, if any
  # @!attribute password2 [rw] End-user secondary password, if any
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute username_type [rw] Type of the username provided
  class LinkOptions < Faraday::Options.new(
    :access_mode,
    :token,
    :username2,
    :username3,
    :password2,
    :encryption_key,
    :username_type,
    :certificate,
    :private_key
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

  # @!class IncomeOptions < Faraday::Options
  # Contains configurable properties of an Income
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute encryption_key [rw] Custom encryption key
  class IncomeOptions < Faraday::Options.new(
    :encryption_key,
    :save_data
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

  # @!class TaxStatusOptions < Faraday::Options
  # Contains configurable properties of a TaxStatus
  # @!attribute save_data [rw] Should data be persisted or not.
  # @!attribute token [rw] OTP token required by the institution
  # @!attribute encryption_key [rw] Custom encryption key
  # @!attribute attach_pdf [rw] Should the PDF file be included in the
  #   response or not.
  class TaxStatusOptions < Faraday::Options.new(
    :token,
    :encryption_key,
    :save_data,
    :attach_pdf
  )
  end
  # @!class WidgetTokenOptions < Faraday::Options
  # Contains configurable properties of a WidgetToken
  # @!attribute scopes [rw] Should have WidgetToken's permssions.
  # @!attribute link_id [rw] Should the WidgetToken be tied to a specific link.
  class WidgetTokenOptions < Faraday::Options.new(
    :scopes,
    :link_id
  )
  end
end
