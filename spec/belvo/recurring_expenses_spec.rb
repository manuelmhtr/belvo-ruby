# frozen_string_literal: true

RSpec.describe Belvo::RecurringExpenses do
  let(:nested_account) do
    {
      id: 'some-account-id',
      name: 'Some account',
      category: 'CHECKING_ACCOUNT',
      currency: 'MXN'
    }
  end
  let(:nested_transactions) do
    {
      id: 'some-transaction-id',
      amount: 100,
      value_date: '2021-07-13',
      description: 'Video Platform Subscription July'
    }
  end

  let(:recurring_expenses_resp) do
    {
      id: 'some-recurring-expense-uuid',
      account: nested_account.transform_keys(&:to_s),
      name: 'video platform subscription',
      transactions: [nested_transactions.transform_keys(&:to_s)],
      frequency: 'MONTHLY',
      average_transaction_amount: 100.0,
      median_transaction_amount: 100.0,
      days_since_last_transaction: 25,
      category: 'Online Platforms & Services',
      payment_type: 'SUBSCRIPTION'
    }
  end

  let(:recurring_expenses) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/recurring-expenses/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: recurring_expenses_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/recurring-expenses/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false
      }
    ).to_return(
      status: 200,
      body: recurring_expenses_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      recurring_expenses.retrieve(link: 'some-link-uuid')
    ).to eq(recurring_expenses_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      recurring_expenses.retrieve(
        link: 'some-link-uuid',
        options: {
          save_data: false
        }
      )
    ).to eq(recurring_expenses_resp.transform_keys(&:to_s))
  end
end
