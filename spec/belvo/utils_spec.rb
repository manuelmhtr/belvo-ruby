# frozen_string_literal: true

RSpec.describe Utils do
  it 'read_file_to_b64 returns nil with bad file' do
    expect(described_class.read_file_to_b64('/bad/path')).to eq(nil)
  end

  it 'read_file_to_b64 works with good file' do
    expect(
      described_class.read_file_to_b64(__dir__ + '/test_file.txt')
    ).to eq('')
  end
end
