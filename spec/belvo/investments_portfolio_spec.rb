# frozen_string_literal: true

RSpec.describe Belvo::InvestmentsPortfolio do
  let(:investments_portfolio_resp) do
    {
      id: '30cb4806-6e00-48a4-91c9-ca55968576c8',
      name: 'Fundos de Investimento',
      type: 'FUND',
      balance_gross: 76,
      balance_net: 77.69,
      currency: 'BRL',
      instruments: []
    }
  end

  let(:investments_portfolio) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/investments/portfolios/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: investments_portfolio_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/investments/portfolios/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false,
        token: 'a-token'
      }
    ).to_return(
      status: 201,
      body: investments_portfolio_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      investments_portfolio.retrieve(link: 'some-link-uuid')
    ).to eq(investments_portfolio_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      investments_portfolio.retrieve(
        link: 'some-link-uuid',
        options: {
          token: 'a-token',
          save_data: false
        }
      )
    ).to eq(investments_portfolio_resp.transform_keys(&:to_s))
  end
end
