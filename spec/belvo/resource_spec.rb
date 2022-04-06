RSpec.describe Belvo::RecurringExpenses do
  describe '#list' do
    let(:session) { instance_double('Belvo::APISession') }
    let(:results) { %w[RESULT1 RESULT2 RESULT3] }
    let(:params) { { foo: 'bar' } }
    let(:resource) { described_class.new(session) }

    before do
      allow(session).to receive(:list)
        .and_yield(results[0])
        .and_yield(results[1])
        .and_yield(results[2])
    end

    context 'when passing a block' do
      it 'yields each result' do
        yielded = []
        response = resource.list { |result| yielded << result }
        expect(response).to be_nil
        expect(yielded).to eq(results)
      end
    end

    context 'when not passing a block' do
      subject(:list) { resource.list }

      it 'returns all the results as array' do
        expect(list).to eq(results)
      end
    end
  end
end
