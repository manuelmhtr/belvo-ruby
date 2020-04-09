# frozen_string_literal: true

RSpec.describe Belvo::Institution do
  let(:nested_form_fields) do
    {
      name: 'username',
      type: 'text',
      label: 'Client number'
    }
  end

  let(:institution_resp) do
    {
      name: 'banamex_mx_retail',
      type: 'bank',
      website: 'https://www.banamex.com/',
      display_name: 'Citibanamex',
      country_codes: ['MX'],
      primary_color: '#056dae',
      logo: 'https://cdn.belvo.co/logos/citibanamex_logo.png',
      form_fields: [nested_form_fields.transform_keys(&:to_s)]
    }
  end

  let(:institutions) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_list_ok
    mock_login_ok
    WebMock.stub_request(:get, 'http://fake.api/api/institutions/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 200,
      body: {
        count: 1,
        next: nil,
        previous: nil,
        results: [institution_resp]
      }.to_json
    )
  end

  it 'can list' do
    mock_list_ok
    expect(institutions.list).to eq([institution_resp.transform_keys(&:to_s)])
  end
end
