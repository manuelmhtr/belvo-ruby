# frozen_string_literal: true

RSpec.describe Belvo::Transaction do
  let(:transaction_resp) do
    {}
  end

  let(:transactions) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/transactions/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        date_to: Date.today.to_s,
        save_data: true
      }
    ).to_return(
      status: 201,
      body: transaction_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/transactions/').with(
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
      body: transaction_resp.to_json
    )
  end

  it 'can create transactions' do
    mock_create_ok
    expect(
      transactions.retrieve(link: 'some-link-uuid', date_from: '2020-01-01')
    ).to eq(transaction_resp.transform_keys(&:to_s))
  end

  it 'can change transaction options when creating' do
    mock_create_with_options
    expect(
      transactions.retrieve(
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        options: {
          token: 'a-token',
          date_to: '2020-01-02',
          save_data: false
        }
      )
    ).to eq(transaction_resp.transform_keys(&:to_s))
  end
end
