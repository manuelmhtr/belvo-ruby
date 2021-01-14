# frozen_string_literal: true

RSpec.describe Belvo::WidgetToken do
  let(:token_resp) do
    {
      access: 'abcde',
      refresh: '123456'
    }
  end

  let(:widget_token) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_request_token_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/token/').with(
      body: {
        id: 'foo',
        password: 'bar',
        scopes: 'read_institutions,write_links,read_links,delete_links'
      }
    ).to_return(
      status: 200,
      body: token_resp.to_json
    )
  end

  def mock_request_widget_token_with_link_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/token/').with(
      body: {
        id: 'foo',
        password: 'bar',
        scopes: 'write_links',
        link_id: 'the-link'
      }
    ).to_return(
      status: 200,
      body: token_resp.to_json
    )
  end

  it 'can create a new token' do
    mock_request_token_ok
    expect(
      widget_token.create
    ).to eq(token_resp.transform_keys(&:to_s))
  end

  it 'can create a new token with link_id and scopes' do
    mock_request_widget_token_with_link_ok
    expect(
      widget_token.create(
        options: { scopes: 'write_links', link_id: 'the-link' }
      )
    ).to eq(token_resp.transform_keys(&:to_s))
  end
end
