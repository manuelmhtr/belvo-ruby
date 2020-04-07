# frozen_string_literal: true

RSpec.describe Belvo::Invoice do
  let(:nested_detail) do
    {
      collected_at: '2019-09-27T13:01:41.941Z',
      description: 'Jan 2020 accounting fees',
      product_identification: '84101600',
      quantity: 1,
      unit_amount: 200,
      unit_description: 'Unidad de servicio',
      unit_code: 'E48',
      pre_tax_amount: 400,
      tax_percentage: 16,
      tax_amount: 64,
      total_amount: 464
    }
  end

  let(:invoice_resp) do
    {
      id: 'some-invoice-uuid',
      link: 'some-link-uuid',
      collected_at: '2019-09-27T13:01:41.941Z',
      type: 'inflow',
      invoice_identification: 'A1A1A1A1-2B2B-3C33-D44D-555555E55EE',
      invoice_date: '2019-12-01',
      sender_id: 'AAA111111AA11',
      sender_name: 'ACME CORP',
      receiver_id: 'BBB222222BB22',
      receiver_name: 'BELVO CORP',
      certification_date: '2019-12-01',
      certification_authority: 'CCC333333CC33',
      cancellation_status: 'string',
      status: 'Vigente',
      cancellation_update_date: '2019-12-02',
      invoice_details: [nested_detail.transform_keys(&:to_s)],
      subtotal_amount: 400,
      tax_amount: 64,
      discount_amount: 10,
      total_amount: 454,
      exchange_rate: 0.052,
      currency: 'MXN',
      payment_type_description: 'string',
      payment_method_description: 'string',
      payment_type: '99',
      payment_method: 'PUE'
    }
  end

  let(:invoices) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/invoices/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-20',
        date_to: '2020-01-31',
        type: 'inflow',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: invoice_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/invoices/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        date_from: '2020-01-20',
        date_to: '2020-01-31',
        type: 'inflow',
        save_data: false,
        token: 'a-token',
        attach_xml: true
      }
    ).to_return(
      status: 201,
      body: invoice_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      invoices.create(
        link: 'some-link-uuid',
        date_from: '2020-01-20',
        date_to: '2020-01-31',
        type: 'inflow'
      )
    ).to eq(invoice_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      invoices.create(
        link: 'some-link-uuid',
        date_from: '2020-01-20',
        date_to: '2020-01-31',
        type: 'inflow',
        options: {
          token: 'a-token',
          save_data: false,
          attach_xml: true
        }
      )
    ).to eq(invoice_resp.transform_keys(&:to_s))
  end
end
