# frozen_string_literal: true

RSpec.describe Belvo::Link do
  let(:single_link_resp) do
    { id: 'some-id', access_mode: 'single', status: 'valid' }
  end

  let(:recurrent_link_resp) do
    { id: 'some-id', access_mode: 'recurrent', status: 'valid' }
  end

  let(:links) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_empty_links_list
    mock_login_ok
    WebMock.stub_request(:get, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 200,
      body: { count: 1, next: nil, previous: nil, results: ['a'] }.to_json
    )
  end

  def mock_post_single_link_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar],
      body: {
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        access_mode: 'single'
      }
    ).to_return(
      status: 201,
      body: single_link_resp.to_json
    )
  end

  def mock_post_recurrent_link_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: recurrent_link_resp.to_json
    ).with(
      body: {
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        access_mode: 'recurrent'
      }
    )
  end

  def mock_post_username_type_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: single_link_resp.to_json
    ).with(
      body: {
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        access_mode: 'single',
        username_type: '001'
      }
    )
  end

  def mock_post_two_usernames_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: single_link_resp.to_json
    ).with(
      body: {
        institution: 'bank',
        username: 'janedoe',
        username2: 'johndoe',
        password: 'secret',
        access_mode: 'single'
      }
    )
  end

  def mock_post_two_passwords_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: single_link_resp.to_json
    ).with(
      body: {
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        password2: 'secondsecret',
        access_mode: 'single'
      }
    )
  end

  def mock_post_cert_key_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/links/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: single_link_resp.to_json
    ).with(
      body: {
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        access_mode: 'single',
        certificate: '',
        private_key: ''
      }
    )
  end

  def mock_put_encryption_key_ok
    mock_login_ok
    WebMock.stub_request(:put, 'http://fake.api/api/links/some-id/').with(
      basic_auth: %w[foo bar]
    ).to_return(
      status: 201,
      body: { id: 'some-id', access_mode: 'single', status: 'valid' }.to_json
    ).with(
      body: {
        password: 'secret',
        encryption_key: 'this-is-so-secret'
      }
    )
  end

  it 'can list links' do
    mock_empty_links_list
    expect(links.list.length).to eq(1)
  end

  it 'can create a link' do
    mock_post_single_link_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret'
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end

  it 'can create a recurrent link' do
    mock_post_recurrent_link_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        options: { access_mode: described_class::AccessMode::RECURRENT }
      )
    ).to eq(recurrent_link_resp.transform_keys(&:to_s))
  end

  it 'can create a link with username_type' do
    mock_post_username_type_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        options: { username_type: '001' }
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end

  it 'can create a link with two usernames' do
    mock_post_two_usernames_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        options: { username2: 'johndoe' }
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end

  it 'can create a link with two passwords' do
    mock_post_two_passwords_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        options: { password2: 'secondsecret' }
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end

  it 'can create a link with certificate and private_key' do
    mock_post_cert_key_ok
    expect(
      links.register(
        institution: 'bank',
        username: 'janedoe',
        password: 'secret',
        options: {
          certificate: __dir__ + '/test_file.txt',
          private_key: __dir__ + '/test_file.txt'
        }
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end

  it 'can update an existing link' do
    mock_put_encryption_key_ok
    expect(
      links.update(
        id: 'some-id',
        password: 'secret',
        options: { encryption_key: 'this-is-so-secret' }
      )
    ).to eq(single_link_resp.transform_keys(&:to_s))
  end
end
