# frozen_string_literal: true

RSpec.describe Belvo::Client do
  it 'raises error when no url given' do
    message = 'You need to provide a URL or a valid environment.'
    expect do
      described_class.new('fake_id', 'fake_secret')
    end.to raise_error(Belvo::BelvoAPIError, message)
  end

  it 'raises error when wrong credentials' do
    WebMock.stub_request(:get, 'http://fake.api/api/').with(
      basic_auth: %w[foo bar]
    ).to_return(status: [401, 'Unauthorized'])
    expect do
      described_class.new('foo', 'bar', 'http://fake.api')
    end.to raise_error(Belvo::BelvoAPIError, 'Login failed.')
  end

  it 'can login when credentials are correct' do
    WebMock.stub_request(:get, 'http://fake.api/api/').with(
      basic_auth: %w[foo bar]
    ).to_return(status: 200)

    expect do
      described_class.new('foo', 'bar', 'http://fake.api')
    end.not_to raise_error
  end

  [
    %w[sandbox https://sandbox.belvo.com],
    %w[development https://development.belvo.com],
    %w[production https://api.belvo.com]
  ].each do |env|
    it 'given an environment the session should have the correct API URL' do
      name = env[0]
      url = format('%<url>s/', url: env[1])
      mock_url = format('%<url>sapi/', url: url)

      WebMock.stub_request(:get, mock_url).to_return(status: 200)

      client = described_class.new('key-id', 'key-password', name)
      expect(client.session.instance_variable_get(:@url)).to eq(url)
    end
  end

  it 'given an URL the session should have the same one' do
    url = 'https://sandbox.belvo.com'

    WebMock.stub_request(
      :get, format('%<url>s/api/', url: url)
    ).to_return(status: 200)

    client = described_class.new('key-id', 'key-password', url)
    expect(client.session.instance_variable_get(:@url)).to eq('https://sandbox.belvo.com/')
  end
end
