# frozen_string_literal: true

RSpec.describe Belvo::Balance do
  let(:nested_account) do
    {
      name: 'Some account',
      category: 'CHECKING_ACCOUNT',
      currency: 'MXN',
      id: '0d3ffb69-f83b-456e-ad8e-208d0998d71d'
    }
  end

  let(:balance_resp) do
    {
      id: '076c66e5-90f5-4e01-99c7-50e32f65ae42',
      collected_at: '2019-11-28T10:27:44.813Z',
      value_date: '2019-10-23T00:00:00.000Z',
      current_balance: 2145.45,
      account: nested_account.transform_keys(&:to_s)
    }
  end

  let(:balances) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/balances/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        date_to: '2020-01-02',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: balance_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/balances/').with(
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
      body: balance_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      balances.retrieve(
        link: 'some-link-uuid', date_from: '2020-01-01', date_to: '2020-01-02'
      )
    ).to eq(balance_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      balances.retrieve(
        link: 'some-link-uuid',
        date_from: '2020-01-01',
        date_to: '2020-01-02',
        options: {
          token: 'a-token',
          save_data: false
        }
      )
    ).to eq(balance_resp.transform_keys(&:to_s))
  end
end
