# frozen_string_literal: true

require 'coveralls'
require 'bundler/setup'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start do
  add_filter '/spec/'
end

Coveralls.wear!

require 'belvo'
require 'belvo/http'
require 'belvo/resources'
require 'belvo/exceptions'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def mock_login_ok
    WebMock.stub_request(:get, 'http://fake.api/api/').with(
      basic_auth: %w[foo bar]
    ).to_return(status: 200)
  end
end
