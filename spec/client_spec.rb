RSpec.describe Belvo::Client do
  it "raises error when no url given" do
    expect {
      Belvo::Client.new(
        "fake_id",
        "fake_secret"
      )
    }.to raise_error(Belvo::BelvoAPIError, "You need to provide a URL.")
  end

  it "raises error when wrong credentials" do
    WebMock.stub_request(
      :get,
      "http://api.belvo.co/api/"
    ).with(basic_auth: ["foo", "bar"]).to_return(status: [401, "Unauthorized"])

    expect {
      Belvo::Client.new(
        "foo",
        "bar",
        "http://api.belvo.co"
      )
    }.to raise_error(Belvo::BelvoAPIError, "Login failed.")
  end
end
