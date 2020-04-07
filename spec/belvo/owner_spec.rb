# frozen_string_literal: true

RSpec.describe Belvo::Owner do
  let(:owner_resp) do
    {
      id: 'c749315b-eec2-435d-a458-06912878564f',
      display_name: 'John Doe',
      first_name: 'John',
      last_name: 'Doe',
      second_last_name: 'Smith',
      phone_number: '+52-XXX-XXX-XXXX',
      email: 'johndoe@belvo.co',
      address: 'Carrer de la Llacuna, 162, 08018 Barcelona',
      collected_at: '2019-09-27T13:01:41.941Z'
    }
  end

  let(:owners) do
    client = Belvo::Client.new('foo', 'bar', 'http://fake.api')
    described_class.new(client.session)
  end

  def mock_create_ok
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/owners/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: true
      }
    ).to_return(
      status: 201,
      body: owner_resp.to_json
    )
  end

  def mock_create_with_options
    mock_login_ok
    WebMock.stub_request(:post, 'http://fake.api/api/owners/').with(
      basic_auth: %w[foo bar],
      body: {
        link: 'some-link-uuid',
        save_data: false,
        token: 'a-token'
      }
    ).to_return(
      status: 201,
      body: owner_resp.to_json
    )
  end

  it 'can create' do
    mock_create_ok
    expect(
      owners.create(link: 'some-link-uuid')
    ).to eq(owner_resp.transform_keys(&:to_s))
  end

  it 'can change options when creating' do
    mock_create_with_options
    expect(
      owners.create(
        link: 'some-link-uuid',
        options: {
          token: 'a-token',
          save_data: false
        }
      )
    ).to eq(owner_resp.transform_keys(&:to_s))
  end
end
