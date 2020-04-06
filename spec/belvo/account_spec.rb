# frozen_string_literal: true

RSpec.describe Belvo::Account do
  let(:account_resp) do
    { id: 'some-account-uuid',
      link: 'some-link-uuid',
      name: 'Checking account',
      type: 'Santander checking',
      number: '0123456',
      category: 'CHECKING_ACCOUNT',
      currency: 'MXN',
      loan_data: nil,
      credit_data: nil,
      collected_at: '2020-04-06T10:10:37.484470+00:00',
      bank_product_id: '1',
      last_accessed_at: nil,
      internal_identification: '987654321',
      public_identification_name: 'CLABE',
      public_identification_value: '123456' }
  end

  let(:accounts) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_accounts_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/accounts/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: account_resp.to_json
    )
  end

  def mock_get_account_ok
    mock_login_ok
    WebMock.stub_request(:get, 'http://fake.api/api/accounts/some-account-uuid/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 200,
      body: account_resp.to_json
    )
  end

  it 'can create accounts' do
    mock_create_accounts_ok
    expect(
      accounts.create(link: 'some-link-uuid')
    ).to eq(account_resp.transform_keys(&:to_s))
  end

  it 'can get an account detail' do
    mock_get_account_ok
    expect(
      accounts.detail('some-account-uuid')
    ).to eq(account_resp.transform_keys(&:to_s))
  end
end
