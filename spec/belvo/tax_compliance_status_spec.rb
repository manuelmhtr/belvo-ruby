# frozen_string_literal: true

RSpec.describe Belvo::TaxComplianceStatus do
  let(:tax_compliance_status_resp) do
    {
      id: 'some-tax-compliance-status-uuid',
      link: 'some-link-uuid',
      collected_at: '2019-09-27T13:01:41.941Z'
    }
  end

  let(:tax_compliance_status) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/tax-compliance-status/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: tax_compliance_status_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/tax-compliance-status/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false,
        token: 'a-token',
        attach_pdf: true
      }
    ).to_return(
      status: 201,
      body: tax_compliance_status_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      tax_compliance_status.retrieve(
        link: 'some-link-uuid'
      )
    ).to eq(tax_compliance_status_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      tax_compliance_status.retrieve(
        link: 'some-link-uuid',
        options: {
          token: 'a-token',
          save_data: false,
          attach_pdf: true
        }
      )
    ).to eq(tax_compliance_status_resp.transform_keys(&:to_s))
  end
end
