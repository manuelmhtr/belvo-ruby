# frozen_string_literal: true

RSpec.describe Environment do
  [
    %w[sandbox https://sandbox.belvo.com],
    %w[development https://development.belvo.com],
    %w[production https://api.belvo.com]
  ].each do |env|
    it 'given an environment name should return a valid API URL' do
      expect(described_class.get_url(env[0])).to eq(env[1])
    end
  end

  it 'given an URL should return the same one as default' do
    expect(
      described_class.get_url('https://sandbox.belvo.com')
    ).to eq('https://sandbox.belvo.com')
  end
end
