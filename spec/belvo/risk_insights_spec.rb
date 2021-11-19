# frozen_string_literal: true

RSpec.describe Belvo::RiskInsights do
  let(:loans_metrics) do
    {
      num_accounts: 1,
      sum_loans_principal: 100.0,
      sum_loans_outstanging: 100.0,
      sum_loans_monthly_payment: 100.0
    }
  end

  let(:balances_metrics) do
    {
      max_balance: 67_779.0,
      min_balance: 67_779.0,
      closing_balance: 67_779.0,
      balance_threshold_x: 1_000.0,
      days_balance_below_0: 0.0,
      days_balance_below_x: 0.0
    }
  end

  let(:cashflow_metrics) do
    {
      sum_negative_1m: 0.0,
      sum_negative_1w: 0.0,
      sum_negative_3m: 73_716.74,
      sum_positive_1m: 0.0,
      sum_positive_1w: 0.0,
      sum_positive_3m: 82_305.25,
      positive_to_negative_ratio_1m: 0.0,
      positive_to_negative_ratio_1w: 0.0,
      positive_to_negative_ratio_3m: 1.12
    }
  end

  let(:credit_cards_metrics) do
    {
      num_accounts: 1,
      sum_credit_used: 100.0,
      sum_credit_limit: 100.0
    }
  end

  let(:transactions_metrics) do
    {
      num_transactions_1m: 0,
      num_transactions_1w: 0,
      num_transactions_3m: 34,
      max_incoming_amount_1m: 9789.98,
      max_incoming_amount_1w: 389.99,
      max_incoming_amount_3m: 9_789.98,
      max_outgoing_amount_1m: 8_646.72,
      max_outgoing_amount_1w: 8_646.72,
      max_outgoing_amount_3m: 8_646.72,
      sum_incoming_amount_1m: 82_305.25,
      sum_incoming_amount_1w: 82_305.25,
      sum_incoming_amount_3m: 82_305.25,
      sum_outgoing_amount_1m: 63_914.13,
      sum_outgoing_amount_1w: 63_914.13,
      sum_outgoing_amount_3m: 63_914.13,
      mean_incoming_amount_1m: 4_331.86,
      mean_incoming_amount_1w: 4_331.86,
      mean_incoming_amount_3m: 4_331.86,
      mean_outgoing_amount_1m: 4_260.94,
      mean_outgoing_amount_1w: 4_260.94,
      mean_outgoing_amount_3m: 4_260.94,
      num_incoming_transactions_1m: 0,
      num_incoming_transactions_1w: 0,
      num_incoming_transactions_3m: 19,
      num_outgoing_transactions_1m: 0,
      num_outgoing_transactions_1w: 0,
      num_outgoing_transactions_3m: 15
    }
  end

  let(:risk_insights_resp) do
    {
      id: 'some-risk-insights-uuid',
      accounts: ['account-id-from-which-information-was-extracted'],
      transactions_metrics: transactions_metrics.transform_keys(&:to_s),
      cashflow_metrics: cashflow_metrics.transform_keys(&:to_s),
      balances_metrics: balances_metrics.transform_keys(&:to_s),
      loans_metrics: loans_metrics.transform_keys(&:to_s),
      credit_cards_metrics: credit_cards_metrics.transform_keys(&:to_s)
    }
  end

  let(:risk_insights) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/risk-insights/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: risk_insights_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/risk-insights/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false
      }
    ).to_return(
      status: 200,
      body: risk_insights_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      risk_insights.retrieve(link: 'some-link-uuid')
    ).to eq(risk_insights_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      risk_insights.retrieve(
        link: 'some-link-uuid',
        options: {
          save_data: false
        }
      )
    ).to eq(risk_insights_resp.transform_keys(&:to_s))
  end
end
