# frozen_string_literal: true

RSpec.describe Belvo::Income do
  let(:nested_account) do
    {
      name: 'NOMINA FLEXIBLE HSBC',
      category: 'CHECKING_ACCOUNT'
    }
  end
  let(:nested_transaction) do
    {
      amount: 24_864.07,
      value_date: '2019-09-13',
      description: 'DEPOSITO NOMINA',
      account: nested_account.transform_keys(&:to_s)
    }
  end

  let(:income_resp) do
    {
      id: 'some-income-uuid',
      link: 'some-link-uuid',
      collected_at: '2019-10-27T13:01:41.941Z',
      value_date: '2019-09-01',
      number_of_income_transactions: 1,
      income_amount: 24_864.07,
      transactions: [nested_transaction.transform_keys(&:to_s)]
    }
  end

  let(:incomes) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/incomes/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: income_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/incomes/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false
      }
    ).to_return(
      status: 201,
      body: income_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      incomes.retrieve(
        link: 'some-link-uuid'
      )
    ).to eq(income_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      incomes.retrieve(
        link: 'some-link-uuid',
        options: {
          save_data: false
        }
      )
    ).to eq(income_resp.transform_keys(&:to_s))
  end
end
