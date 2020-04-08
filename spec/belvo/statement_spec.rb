# frozen_string_literal: true

RSpec.describe Belvo::Statement do
  let(:nested_account) do
    {
      name: 'Some account',
      category: 'CHECKING_ACCOUNT',
      currency: 'MXN',
      id: 'some-account-uuid'
    }
  end

  let(:statement_resp) do
    {
      id: 'some-statement-uuid',
      link: 'some-link-uuid',
      account: nested_account.transform_keys(&:to_s),
      collected_at: '2019-09-27T13:01:41.941Z',
      RFC: 'some-rfc',
      CLABE: 'some-clabe',
      transactions: [],
      client_number: 'some-client-number',
      final_balance: 5621.12,
      previous_balance: 5621.12,
      account_number: 'some-account-number',
      period_end_date: '2020-01-31',
      period_start_date: '2020-01-01',
      total_inflow_amount: 5621.12,
      total_outflow_amount: 5621.12,
      total_inflow_transactions: 12,
      total_outflow_transactions: 12
    }
  end

  let(:statements) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/statements/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        account: 'some-account-uuid',
        year: 2020,
        month: 1,
        save_data: true
      }
    ).to_return(
      status: 201,
      body: statement_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/statements/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        account: 'some-account-uuid',
        year: 2020,
        month: 1,
        save_data: false,
        token: 'a-token',
        attach_pdf: true
      }
    ).to_return(
      status: 201,
      body: statement_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      statements.retrieve(
        link: 'some-link-uuid',
        account: 'some-account-uuid',
        year: 2020,
        month: 1
      )
    ).to eq(statement_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      statements.retrieve(
        link: 'some-link-uuid',
        account: 'some-account-uuid',
        year: 2020,
        month: 1,
        options: {
          token: 'a-token',
          save_data: false,
          attach_pdf: true
        }
      )
    ).to eq(statement_resp.transform_keys(&:to_s))
  end
end
