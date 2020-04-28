# frozen_string_literal: true

RSpec.describe Belvo::FinancialReport do
  let(:nested_owner) do
    {
      id: 'c749315b-eec2-435d-a458-06912878564f',
      display_name: 'John Doe',
      first_name: 'John',
      last_name: 'Doe',
      second_last_name: 'Smith',
      phone_number: '+52-XXX-XXX-XXXX',
      email: 'johndoe@belvo.co',
      address: 'Carrer de la Llacuna, 162, 08018 Barcelona',
      collected_at: '2019-09-27T13:01:41.941Z',
    }
  end

  let(:nested_balance) do
    {
      id: '076c66e5-90f5-4e01-99c7-50e32f65ae42',
      collected_at: '2019-11-28T10:27:44.813Z',
      value_date: '2019-10-23T00:00:00.000Z',
      current_balance: 2145.45,
    }
  end

  let(:nested_account) do
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
      balances: nested_balance.transform_keys(&:to_s),
      transactions: {},
      public_identification_name: 'CLABE',
      public_identification_value: '123456',
    }
  end

  let(:financial_report_response) do
    {
      id: '076c66e5-90f5-4e01-99c7-50e32f65ae42',
      link: 'ea3c65dd-c006-4647-9da6-690d3c418ceb',
      value_date: '2019-10-23T00:00:00.000Z',
      collected_at: '2020-04-21T10:02:05.712604+00:00',
      accounts_count: 1,
      institution: 'hsbc_mx_retail',
      date_first_transaction: '2020-02-03',
      days_available: 79,
      owners: nested_owner.transform_keys(&:to_s),
      accounts: nested_account.transform_keys(&:to_s),
      balances: nested_balance.transform_keys(&:to_s),
    }
  end

  let(:financial_report) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/financial-reports/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: financial_report_response.to_json
    )
  end

  def mock_create_filtering_account
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/financial-reports/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        account: 'some-account-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: financial_report_response.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      financial_report.retrieve(link: 'some-link-uuid')
    ).to eq(financial_report_response.transform_keys(&:to_s))
  end

  it 'can create filtering by account' do
    mock_create_filtering_account
    expect(
      financial_report.retrieve(link: 'some-link-uuid', options: {account: 'some-account-uuid'})
    ).to eq(financial_report_response.transform_keys(&:to_s))
  end
end
