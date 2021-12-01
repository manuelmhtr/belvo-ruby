# frozen_string_literal: true

RSpec.describe Belvo::InvestmentsTransaction do
  let(:investments_transaction_resp) do
    {
      id: 'f3cd25ba-d109-4ddf-8d29-624c26cbee3f',
      link: 'f3cd25ba-d109-4ddf-8d29-624c26cbee3f',
      collected_at: '2021-03-11T14:38:02.351Z',
      created_at: '2021-03-11T14:36:00.351Z',
      portfolio: {},
      instrument: {},
      settlement_date: '13-08-2021',
      operation_date: '07-08-2021',
      description: 'Stock acquisition',
      type: 'BUY',
      quantity: 18.25,
      amount: 18.25,
      price: 10,
      currency: 'BRL',
      fees: 18.5
    }
  end

  let(:investments_transaction) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/investments/transactions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        date_to: Date.today.to_s,
        save_data: true
      }
    ).to_return(
      status: 201,
      body: investments_transaction_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/investments/transactions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        date_to: '2020-01-02',
        save_data: false,
        token: 'a-token'
      }
    ).to_return(
      status: 201,
      body: investments_transaction_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      investments_transaction.retrieve(
        link: 'some-link-uuid',
        date_from: '2020-01-01'
      )
    ).to eq(investments_transaction_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      investments_transaction.retrieve(
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        options: {
          date_to: '2020-01-02',
          token: 'a-token',
          save_data: false
        }
      )
    ).to eq(investments_transaction_resp.transform_keys(&:to_s))
  end
end
