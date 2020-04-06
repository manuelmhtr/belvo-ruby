# frozen_string_literal: true

RSpec.describe Belvo::Client do
  it 'raises error when no url given' do
    expect do
      described_class.new('fake_id', 'fake_secret')
    end.to raise_error(Belvo::BelvoAPIError, 'You need to provide a URL.')
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
end
